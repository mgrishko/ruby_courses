class ReceiversController < ApplicationController
  before_filter :require_user

  def create
    @item = current_user.items.find(params[:receiver][:item_id])
    @user = User.find_by_gln(params[:receiver][:gln])
    if @user && @item
      @receiver = Receiver.find(:first, :conditions => {:item_id => @item.id, :user_id => @user.id})
      unless @receiver
	@receiver = Receiver.create(:item => @item, :user => @user)
      end
    end
    @receivers = Receiver.find(:all, :conditions => {:item_id => @item.id})
    @retailers = User.find(:all, :conditions => {:role => 'retailer'})
  end

  def destroy
    @receiver = Receiver.find(:first, :conditions => {:id => params[:id]})
    @item = @receiver.item
    if @item.user_id == current_user.id
      @receiver.destroy
    end
    @receivers = Receiver.find(:all, :conditions => {:item_id => @item.id})
    @retailers = User.find(:all, :conditions => {:role => 'retailer'})
  end

end
