class MessagesController < ApplicationController
  before_filter :require_user

  def index
    comments = []
    if current_user.supplier?
      comments = current_user.item_comments.where("comments.user_id != ?", current_user.id).order("id DESC")
    else # current_user.retailer?
      # в разделе выводятся все комментарии поставщиков к айтемам на которые подписан ритейлер.
      # сортировка по убыванию даты
      #FIXME: сомневаюсь в правильности последовательности.
      active_subscriptions = current_user.subscriptions.active.where(:specific => true)
      suppliers = active_subscriptions.map{|s| s.supplier}.map{|s| s.id}
      public_suppliers_base_items = BaseItem.published.where(:user_id => suppliers, :private=> false).to_ids
      private_suppliers_base_items = BaseItem.published.where(:user_id => suppliers, :private=> true).to_ids
      this_receiver_ids = Receiver.where(:user_id => current_user.id ).map{|r| r.base_item_id}
      ids = public_suppliers_base_items | (private_suppliers_base_items & this_receiver_ids)
      authors = suppliers << current_user.id
      comments = Comment.roots.where(:base_item_id => ids,:user_id => authors).order(" 1 DESC")
    end
    @comments = comments.paginate :page => params[:page], :per_page => 10
    @message_info = true

  end
end

