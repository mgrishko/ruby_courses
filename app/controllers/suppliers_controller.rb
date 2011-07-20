class SuppliersController < ApplicationController
  before_filter :require_user

  def index
    @users = User.suppliers
    if params[:tag]
      conditions = ["user_tags.author_id = ? and user_tags.tag_id = ?", current_user.id, params[:tag]]
    end
    if params[:subscribed]
      conditions = ["subscriptions.retailer_id = ?", current_user.id]
    end
    # FIXME maybe we must combine the above two?
    @users = @users.paginate :page => params[:page], :per_page => 10, :conditions => conditions, :include => [:user_tags, :subscribers]
    @clouds = UserTag.find(:all, :select => "tag_id, count(*) as q", :group=>"tag_id", :conditions => {:author_id => current_user.id}) #ok
  end

  def show
    BaseItem.per_page = 12
    if params[:id].to_s == 'all'
      #
      get_bi_filters current_user, nil, :all_suppliers => true
    else
      @supplier = User.find(params[:id])
      get_bi_filters current_user, @supplier
    end

    @base_items = BaseItem.get_base_items :user_id => (@supplier ? @supplier.id : nil),
      :brand => params[:brand],
      :manufacturer_name => params[:manufacturer_name],
      :functional => params[:functional],
      :tag => params[:tag],
      :retailer_id => current_user.id,
      :search => params[:search],
      :page => params[:page]
  end
end

