class ReceiversController < ApplicationController
  before_filter :require_user
  load_and_authorize_resource

  def create
    @base_item = current_user.base_items.find(params[:receiver][:base_item_id])
    @user = User.find_by_gln(params[:receiver][:gln])
    if @user && @base_item
      @receiver = Receiver.find(:first, :conditions => {:base_item_id => @base_item.id, :user_id => @user.id})
      unless @receiver
        @receiver = Receiver.create(:base_item => @base_item, :user => @user)
      end
    end
    @receivers = Receiver.find(:all, :conditions => {:base_item_id => @base_item.id})
    @retailers = User.retailers
  end

  def destroy
    @base_item = @receiver.base_item
    if @base_item.item.user_id == current_user.id
      @receiver.destroy
    end
    @receivers = Receiver.find(:all, :conditions => {:base_item_id => @base_item.id})
    @retailers = User.retailers
  end

end
