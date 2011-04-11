class SuppliersController < ApplicationController
  before_filter :require_user

  def index
    @users = User.paginate :page => params[:page], :per_page => 10, :conditions => {:role => 'supplier'}
  end

  def show
    @supplier = User.find(params[:id])
    @base_items = BaseItem.get_base_items :user_id => @supplier.id,
					  :brand => params[:brand],
					  :manufacturer_name => params[:manufacturer_name],
					  :functional => params[:functional],
					  :tag => params[:tag]
    get_filters_data_for_base_items
  end
end
