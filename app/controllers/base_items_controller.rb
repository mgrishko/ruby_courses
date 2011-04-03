class BaseItemsController < ApplicationController
  before_filter :require_user

  def index
    @conditions = ["b.brand = ?",params[:brand]] if params[:brand]
    @conditions = ["b.manufacturer_name = ?", params[:manufacturer_name]] if params[:manufacturer_name]
    @conditions = ["functional = ?", params[:functional]] if params[:functional]
    if params[:tag]
      @base_items = current_user.base_items.find_by_sql(["select a.* from base_items as a left join items i on a.item_id = i.id left join clouds c on i.id = c.item_id where c.user_id = #{current_user.id} and c.tag_id = ? and a.id = (select b.id from base_items b where a.item_id = b.item_id and b.status='published' and b.user_id = #{current_user.id} order by created_at desc limit 1) order by a.created_at desc", params[:tag]])
    else 
      if @conditions
	@base_items = current_user.base_items.find_by_sql(["select a.* from base_items as a where a.id = (select b.id from base_items b where a.item_id = b.item_id and b.status='published' and b.user_id = #{current_user.id} and "+@conditions.first.to_s+" order by created_at desc limit 1) order by a.created_at desc", @conditions.last])
      else
	@base_items = current_user.base_items.find_by_sql("select a.* from base_items as a where a.id = (select b.id from base_items b where a.item_id = b.item_id and b.status='published' and b.user_id = #{current_user.id} order by created_at desc limit 1) order by a.created_at desc")
      end
    end
    
    @clouds = current_user.clouds.find(:all, :select => "tag_id, count(*) as q", :group=>"tag_id")
    @brands = BaseItem.find_by_sql("select a.brand, count(*) as q from base_items a where a.id = (select b.id from base_items b where a.item_id = b.item_id and b.status='published' and b.user_id = #{current_user.id} order by created_at desc limit 1) group by brand")
    @manufacturers = BaseItem.find_by_sql("select a.manufacturer_name, count(*) as q from base_items a where a.id = (select b.id from base_items b where a.item_id = b.item_id and b.status='published' and b.user_id = #{current_user.id} order by created_at desc limit 1) group by manufacturer_name");
    #functional name
    @functionals = BaseItem.find_by_sql("select a.functional, count(*) as q from base_items a where a.id = (select b.id from base_items b where a.item_id = b.item_id and b.status='published' and b.user_id = #{current_user.id} order by created_at desc limit 1) group by functional");
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
    @retailer_attribute = RetailerAttribute.find(:first, :conditions => {:user_id => current_user.id, :item_id => @base_item.item.id})||RetailerAttribute.new
    @clouds = Cloud.find(:all, :conditions => {:user_id => current_user.id, :item_id => @base_item.item.id})
  end

  def new
    session[:base_item_params] ||= {}
    @base_item = BaseItem.new(session[:base_item_params])  
    @base_item.current_step = session[:base_item_step]

    #if params[:base].nil?
    #  @base_item = current_user.base_items.new
    #else
    #  @base_item = current_user.base_items.find(params[:base].to_i)
    #end
  end

  def edit
    @base_item = current_user.base_items.find(params[:id])
  end

  #def published
  #  @base_item = current_user.base_items.find(params[:id])
  #  @base_item.revert_to(@base_item.published.last.number) unless @base_item.published.empty?
  #  render 'edit'
  #end

  def create
    session[:base_item_params].deep_merge!(params[:base_item]) if params[:base_item]
    @base_item = current_user.base_items.new(session[:base_item_params])
    @base_item.current_step = session[:base_item_step]
    if @base_item.valid?
      if params[:back_button]  
	@base_item.previous_step
      elsif @base_item.last_step?
	if @base_item.all_valid?
	  i = current_user.items.new()
	  i.base_items << @base_item
	  i.save
	  session[:base_item_step] = session[:base_item_params] = nil
	  if params[:publish] && @base_item.publish!
	    flash[:notice] = 'BaseItem was successfully created and sent'
	  else
	    flash[:notice] = 'BaseItem was successfully created.'
	  end
	  return redirect_to(@base_item)
	end
      else
	@base_item.next_step
      end
      session[:base_item_step] = @base_item.current_step
    end
    render 'new' 
    #@base_item = current_user.base_items.new(params[:base_item])

    #generate_attachment
    #if @base_item.save
    #  if params[:publish] && @base_item.publish!
    #    flash[:notice] = 'BaseItem was successfully created and sent'
    #  else
    #    flash[:notice] = 'BaseItem was successfully created.'
    #  end
    #  redirect_to(@base_item)
    #else
    #  render 'new'
    #end
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

  def published
    @base_item = current_user.base_items.find params[:id]
    #generate_attachment
    if @base_item.draft? and params[:cancel]
      @base_item.destroy
    else
      @base_item.publish!
    end
    redirect_to base_items_url
  end

  def draft
    @base_item = current_user.base_items.find params[:id]
    if @base_item.published?
      #make new base_item.tree
      n = BaseItem.new(@base_item.attributes)
      n.created_at = n.updated_at = nil
      n.draft!
      #n.save
      
      map_id = {}
      
      roots = @base_item.packaging_items.find_all{|pi| pi.parent_id == nil}
      roots.each  do |root|
	pi = n.packaging_items.new(root.attributes)
	pi.user = current_user
	pi.save

	#old new
	map_id[root.id] = pi.id

	root.descendants.each do |d|
	  pi = n.packaging_items.new(d.attributes)
	  pi.user = current_user
	  pi.parent_id = map_id[d.parent_id]
	  pi.save

	  map_id[d.id] = pi.id
	end
      end
      #end
      #redirect_to :action => "show", :id => n.id
      redirect_to base_item_path(n)
    end
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
