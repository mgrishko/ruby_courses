class RetailerAttributesController < ApplicationController
  before_filter :require_user
  before_filter :find_item
  
  def show
    @retailer_attribute = RetailerAttribute.find(:first, :conditions => {:user_id => current_user.id, :item_id => @item.id})
  end
  
  def new
    @retailer_attribute = @item.retailer_attributes.new()
  end
  
  def edit
    @retailer_attribute = @item.retailer_attributes.find(:first, :conditions => {:user_id => current_user.id})
    render :new
  end

  def create
    @retailer_attribute = @item.retailer_attributes.new(params[:retailer_attribute])
    @r = RetailerAttribute.find(:first, :conditions => {:user_id => current_user.id, :item_id => params[:retailer_attribute][:item_id]})
    if @r
      @r.update_attributes(params[:retailer_attribute])
    else
      @retailer_attribute.user_id = current_user.id
      @retailer_attribute.save
    end
    respond_to do |format|
      format.js
    end
  end

  def update
    @retailer_attribute = RetailerAttribute.find(:first, :conditions => {:user_id => current_user.id, :id => params[:id]})
    @retailer_attribute.update_attributes(params[:retailer_attribute])
    @retailer_attribute.save
    respond_to do |format|
      format.js
    end
  end
  
  private
  def find_item
    @item = Item.find(params[:retailer_attribute][:item_id])
  end
end
