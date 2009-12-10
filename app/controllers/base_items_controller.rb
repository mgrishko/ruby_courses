class BaseItemsController < ApplicationController
  before_filter :require_user
  @@model = BaseItem

  # GET /articles
  # GET /articles.xml
  def index
    @base_items = BaseItem.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @base_items }
    end
  end

  # GET /articles/1
  # GET /articles/1.xml
  def show
    @base_item = BaseItem.find(params[:id])
    @packaging_items = @base_item.packaging_items

    respond_to do |format|
      format.html { render 'show', :layout => 'base_item_show' }
      format.xml  { render :xml => @base_item }
    end
  end

  # GET /articles/new
  # GET /articles/new.xml
  def new
    if params[:base].nil?
      @base_item = BaseItem.new
    else
      @base_item = BaseItem.find(params[:base].to_i)
    end

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @base_item }
    end
  end

  # GET /articles/1/edit
  def edit
    @base_item = BaseItem.find(params[:id])
  end

  def published
    @base_item = BaseItem.find(params[:id])
    @base_item.revert_to(@base_item.published.last.number) unless @base_item.published.empty?
    render 'edit'
  end

  # POST /articles
  # POST /articles.xml
  def create
    @base_item = BaseItem.new(params[:article])

    generate_attachment
    respond_to do |format|
      if @base_item.save
        if params[:publish] && @base_item.publish!
          flash[:notice] = 'BaseItem was successfully created and sent'
        else
          flash[:notice] = 'BaseItem was successfully created.'
        end
        format.html { redirect_to(@base_item) }
        format.xml  { render :xml => @base_item, :status => :created, :location => @base_item }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @base_item.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /articles/1
  # PUT /articles/1.xml
  def update
    @base_item = BaseItem.find(params[:id])

    BaseItem.transaction do
      respond_to do |format|
        if @base_item.update_attributes(params[:article])
          @base_item.draft!

          flash[:notice] = 'BaseItem was successfully updated.'
          format.html { redirect_to(@base_item) }
          format.xml  { head :ok }
        else
          format.html { render :action => "edit" }
          format.xml  { render :xml => @base_item.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /articles/1
  # DELETE /articles/1.xml
  def destroy
    @base_item = BaseItem.find(params[:id])
    @base_item.destroy

    respond_to do |format|
      format.html { redirect_to(base_items_url) }
      format.xml  { head :ok }
    end
  end

  def publish
    @base_item = BaseItem.find params[:id]
    generate_attachment
    @base_item.publish!
    redirect_to base_items_url
  end

  def accept
    @base_item = BaseItem.find params[:id]
    @base_item.accept!
    redirect_to base_items_url
  end

  def reject
    @base_item = BaseItem.find params[:id]
    @base_item.reject!
    redirect_to base_items_url
  end

  # GET /approve_emails
  #def approve_emails
    #@emails = BaseItem.fetch_and_approve
  #end

  # GET /articles/auto_complete_for_record_value
  def auto_complete_for_record_value
    @items = Gpc.find_complete_values(params[:record][:value])

    render :inline => "<%= auto_complete_result(@items, 'name') %>"
  end

  private

  def generate_attachment
    f = File.new("#{RECORDS_OUT_DIR}/#{@base_item.id}.xml", 'w')
    f.write(render_to_string :template => 'base_items/attachment.xml', :layout => false)
    f.close
  end

end
