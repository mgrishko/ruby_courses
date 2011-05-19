class SuppliersController < ApplicationController
  before_filter :require_user

  def index
    conditions = ["users.role = 'supplier'"]
    if params[:tag]
      conditions = ["users.role = 'supplier' and user_tags.author_id = ? and user_tags.tag_id = ?", current_user.id, params[:tag]]
    end
    if params[:subscribed]
      conditions = ["users.role = 'supplier' and subscriptions.retailer_id = ?", current_user.id]
    end
    @users = User.paginate :page => params[:page], :per_page => 10, :conditions => conditions, :include => [:user_tags, :subscribers]
    @clouds = UserTag.find(:all, :select => "tag_id, count(*) as q", :group=>"tag_id", :conditions => {:author_id => current_user.id}) #ok
  end

  def show
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
