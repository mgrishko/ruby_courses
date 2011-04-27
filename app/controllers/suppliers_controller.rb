class SuppliersController < ApplicationController
  before_filter :require_user

  def index
    @users = User.paginate :page => params[:page], :per_page => 10, :conditions => {:role => 'supplier'}
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
