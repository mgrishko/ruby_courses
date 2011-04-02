class RetailerAttributesController < ApplicationController
  before_filter :require_user

  def create
    @retailer_attribute = RetailerAttribute.new(params[:retailer_attribute])
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
    @retailer_attribute = RetailerAttribute.find(params[:id])
    @retailer_attribute.update_attributes(params[:retailer_attribute])
    @retailer_attribute.save
    respond_to do |format|
      format.js
    end
  end
end
