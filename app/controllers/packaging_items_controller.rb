class PackagingItemsController < ApplicationController
  before_filter :require_user
  before_filter :require_article
  before_filter :check_for_parent
  before_filter :require_packaging_item, :only => [:show, :edit, :destroy, :update]
  @@model = PackagingItem

  def check_for_parent
    if params[:parent_id]
      @parent = PackagingItem.find(params[:parent_id].to_i)
    end
  end

  def require_article
    @article = Article.find(params[:article_id])
  end

  def require_packaging_item
    @packaging_item = PackagingItem.find_by_id_and_article_id(params[:id], @article.id)
    
    if @packaging_item.nil?
      raise ActiveRecord::RecordNotFound
    end
  end
  # GET /packaging_items
  # GET /packaging_items.xml
  def index
    if @parent
      @packaging_items = @parent.children
    else
      @packaging_items = @article.packaging_items
    end

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @packaging_items }
    end
  end

  # GET /packaging_items/1
  # GET /packaging_items/1.xml
  def show

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @packaging_item }
    end
  end

  # GET /packaging_items/new
  # GET /packaging_items/new.xml
  def new
    @packaging_item = PackagingItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @packaging_item }
    end
  end

  # GET /packaging_items/1/edit
  def edit
    @packaging_item = PackagingItem.find(params[:id])
  end

  # POST /packaging_items
  # POST /packaging_items.xml
  def create
    @packaging_item = PackagingItem.new(params[:packaging_item])

    if params[:parent_id]
      @packaging_item.packaging_item_id = @parent.id
    end

    @packaging_item.article_id = @article.id

    respond_to do |format|
      if @packaging_item.save
        flash[:notice] = 'PackagingItem was successfully created.'
        format.html { redirect_to(@article) }
        format.xml  { render :xml => @packaging_item, :status => :created, :location => @packaging_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @packaging_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /packaging_items/1
  # PUT /packaging_items/1.xml
  def update
    respond_to do |format|
      if @packaging_item.update_attributes(params[:packaging_item])
        flash[:notice] = 'PackagingItem was successfully updated.'
        format.html { redirect_to(@article) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @packaging_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /packaging_items/1
  # DELETE /packaging_items/1.xml
  def destroy
    @packaging_item.destroy

    respond_to do |format|
      format.html { redirect_to(@article) }
      format.xml  { head :ok }
    end
  end
end
