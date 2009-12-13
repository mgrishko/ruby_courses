class PackagingItemsController < ApplicationController
  before_filter :require_user
  before_filter :find_base_item

  def index
    @packaging_items = @base_item.packaging_items
  end

  def show
    @packaging_item = @base_item.packaging_items.find(params[:id])
  end

  def new
    @packaging_item = @base_item.packaging_items.new
  end

  def new_sub
    @packaging_item = @base_item.packaging_items.new({ :parent_id => params[:id] })

    render 'new'
  end

  def edit
    @packaging_item = @base_item.packaging_items.find(params[:id])
  end

  def create
    @packaging_item = @base_item.packaging_items.new(params[:packaging_item])

    if @packaging_item.save
      flash[:notice] = 'PackagingItem was successfully created.'
      redirect_to(@base_item)
    else
      render :action => "new"
    end
  end

  def update
    @packaging_item = @base_item.packaging_items.find(params[:id])

    if @packaging_item.update_attributes(params[:packaging_item])
      flash[:notice] = 'PackagingItem was successfully updated.'
      redirect_to(@base_item)
    else
      render :action => "edit"
    end
  end

  def destroy
    @packaging_item = @base_item.packaging_items.find(params[:id])
    @packaging_item.destroy

    redirect_to(@base_item)
  end

  private

  def find_base_item
    @base_item = current_user.base_items.find(params[:base_item_id])
  end

end
