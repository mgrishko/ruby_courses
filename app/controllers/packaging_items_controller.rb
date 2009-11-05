class PackagingItemsController < ApplicationController
  before_filter :require_article

  def require_article
    @article = Article.find(params[:article_id])
  end
  # GET /packaging_items
  # GET /packaging_items.xml
  def index
    @packaging_items = @article.packaging_items

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @packaging_items }
    end
  end

  # GET /packaging_items/1
  # GET /packaging_items/1.xml
  def show
    @packaging_item = PackagingItem.find(params[:id])

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
    @packaging_item.article_id = @article.id

    respond_to do |format|
      if @packaging_item.save
        flash[:notice] = 'PackagingItem was successfully created.'
        format.html { redirect_to([@article, @packaging_item]) }
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
    @packaging_item = PackagingItem.find(params[:id])

    respond_to do |format|
      if @packaging_item.update_attributes(params[:packaging_item])
        flash[:notice] = 'PackagingItem was successfully updated.'
        format.html { redirect_to([@article, @packaging_item]) }
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
    @packaging_item = PackagingItem.find(params[:id])
    @packaging_item.destroy

    respond_to do |format|
      format.html { redirect_to(packaging_items_url) }
      format.xml  { head :ok }
    end
  end
end
