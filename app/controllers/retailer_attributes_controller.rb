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
    if retailer_attribute_data_exists?
      @retailer_attribute = RetailerAttribute.find(:first, :conditions => {:user_id => current_user.id, :item_id => params[:retailer_attribute][:item_id]})
      if @retailer_attribute
	@retailer_attribute.update_attributes(params[:retailer_attribute])
      else
	@retailer_attribute = @item.retailer_attributes.new(params[:retailer_attribute])
	@retailer_attribute.user_id = current_user.id
	@retailer_attribute.save
      end
      Event.log(current_user, @retailer_attribute)
    end
    respond_to do |format|
      format.js
    end
  end

  def update
    @retailer_attribute = RetailerAttribute.find(:first, :conditions => {:user_id => current_user.id, :id => params[:id]})
    if retailer_attribute_data_exists?
      @retailer_attribute.update_attributes(params[:retailer_attribute])
      @retailer_attribute.save
      Event.log(current_user, @retailer_attribute)
    else
      @retailer_attribute.destroy
    end
    respond_to do |format|
      format.js
    end
  end
  
  private
  def find_item
    @item = Item.find(params[:retailer_attribute][:item_id])
  end
  
  def retailer_attribute_data_exists?
    p = params[:retailer_attribute]
    [p[:retailer_article_id],p[:retailer_classification],p[:retailer_item_description],p[:retailer_comment]].join.length > 0
  end
end
