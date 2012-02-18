class MessagesController < ApplicationController
  before_filter :require_user

  def index
    return render_404 unless can? :read, Comment
    comments = []
    if current_user.supplier?
      comments = current_user.item_comments.where("comments.user_id != ?", current_user.id).order("id DESC")
    else # current_user.retailer?
      # в разделе выводятся все комментарии поставщиков к айтемам на которые подписан ритейлер.
      # сортировка по убыванию даты
      #FIXME: сомневаюсь в правильности последовательности.
      active_subscriptions =
        current_user.subscriptions.active.where(:specific => true)
      suppliers = active_subscriptions.map{|s| s.supplier}.to_ids
      public_suppliers_base_items =
        BaseItem.published.where(:user_id => suppliers,
                                 :private=> false).to_ids
      private_suppliers_base_items =
        BaseItem.published.where(:user_id => suppliers,
                                 :private=> true).to_ids
      this_receiver_ids =
        Receiver.where(:user_id => current_user.id ).map do |r|
          r.base_item_id
        end
      ids = public_suppliers_base_items |
        (private_suppliers_base_items & this_receiver_ids)
      authors = suppliers << current_user.id
      comments = Comment.roots.where(:base_item_id => ids,
                              :user_id => authors).order(" 1 DESC")
    end
    @comments = comments.paginate(:page => params[:page],
                                  :per_page => 10)
    @message_info = true

  end
end
