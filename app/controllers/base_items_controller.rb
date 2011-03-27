class BaseItemsController < ApplicationController
  before_filter :require_user

  def index
    @base_items = current_user.base_items.find(:all)
  end

  def show
    if params[:view]
      @view_only = true;
      @base_item = BaseItem.find(params[:id])
      @packaging_items = @base_item.packaging_items
    else
      @base_item = current_user.base_items.find(params[:id])
      @packaging_items = @base_item.packaging_items
    end
  end

  def new
    if params[:base].nil?
      @base_item = current_user.base_items.new
    else
      @base_item = current_user.base_items.find(params[:base].to_i)
    end
  end

  def edit
    @base_item = current_user.base_items.find(params[:id])
  end

  def published
    @base_item = current_user.base_items.find(params[:id])
    @base_item.revert_to(@base_item.published.last.number) unless @base_item.published.empty?
    render 'edit'
  end

  def create
    @base_item = current_user.base_items.new(params[:base_item])

    generate_attachment
    if @base_item.save
      if params[:publish] && @base_item.publish!
        flash[:notice] = 'BaseItem was successfully created and sent'
      else
        flash[:notice] = 'BaseItem was successfully created.'
      end
      redirect_to(@base_item)
    else
      render 'new'
    end
  end

  def update
    @base_item = current_user.base_items.find(params[:id])

    BaseItem.transaction do
      if @base_item.update_attributes(params[:base_item])
        @base_item.draft!

        respond_to do |format|
          format.html { redirect_to(@base_item) }
          format.js
        end
      else
        render 'edit'
      end
    end
  end

  def destroy
    @base_item = current_user.base_items.find(params[:id])
    @base_item.destroy

    redirect_to(base_items_url)
  end

  def publish
    @base_item = current_user.base_items.find params[:id]
    generate_attachment
    @base_item.publish!
    redirect_to base_items_url
  end

  def accept
    @base_item = current_user.base_items.find params[:id]
    @base_item.accept!
    redirect_to base_items_url
  end

  def reject
    @base_item = current_user.base_items.find params[:id]
    @base_item.reject!
    redirect_to base_items_url
  end

  # GET /approve_emails
  #def approve_emails
    #@emails = BaseItem.fetch_and_approve
  #end

  def auto_complete_for_base_item_gpc_name
    @gpcs = Gpc.find(:all, :conditions => ["LOWER(name) LIKE ?", "%#{params[:base_item][:gpc_name].downcase}%"])
    render :inline => "<%= auto_complete_result(@gpcs, 'name') %>"
  end

  private

  def generate_attachment
    f = File.new("#{RECORDS_OUT_DIR}/#{@base_item.id}.xml", 'w')
    f.write(render_to_string :template => 'base_items/attachment.xml', :layout => false)
    f.close
  end

end
