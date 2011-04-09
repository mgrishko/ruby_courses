class BaseItemsController < ApplicationController
  before_filter :require_user

  def index
    @base_items = BaseItem.get_base_items :user_id => current_user.id,
                                          :manufacturer_name => params[:manufacturer_name],
                                          :functional => params[:functional],
                                          :brand => params[:brand], 
                                          :tag => params[:tag]
    get_filters_data_for_base_items
  end

  def show
    if params[:view]
      @view_only = true;
      @base_item = BaseItem.find(params[:id])
      @packaging_items = @base_item.packaging_items
      if current_user.retailer? && !@base_item.subscription_result.accepted?
        @accepted_base_item = BaseItem.all(:conditions => ["item_id = ? AND sr.status = 'accepted' AND base_items.id < ? AND base_items.status = 'published'", @base_item.item_id,@base_item.id],
                                            :joins => 'JOIN subscription_results sr ON base_items.id = sr.base_item_id',
                                            :order => 'base_items.id DESC').first
        #@accepted_packaging_items = @accepted_base_item.packaging_items
      end
    else
      @base_item = current_user.base_items.find(params[:id])
      @packaging_items = @base_item.packaging_items
    end
    ####
    if params[:step]
      return render 'update_step2'
    end
    ####
    @retailer_attribute = RetailerAttribute.find(:first, :conditions => {:user_id => current_user.id, :item_id => @base_item.item.id})||RetailerAttribute.new
    @clouds = Cloud.find(:all, :conditions => {:user_id => current_user.id, :item_id => @base_item.item.id})
  end

  def new
    if current_user.retailer?
      redirect_to :action => 'index'
    end
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
    @clouds = Cloud.find(:all, :conditions => {:user_id => current_user.id, :item_id => @base_item.item.id})
    if params[:step]
      @base_item.next_step
      render 'edit_step2'
    end
  end

  #def published
  #  @base_item = current_user.base_items.find(params[:id])
  #  @base_item.revert_to(@base_item.published.last.number) unless @base_item.published.empty?
  #  render 'edit'
  #end

  def create
    # only suppliers can create BI
    if current_user.retailer?
      return redirect_to :action => 'index'
    end
    #/only

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
    @clouds = Cloud.find(:all, :conditions => {:user_id => current_user.id, :item_id => @base_item.item.id})
    if params[:step]
      @base_item.next_step
      if @base_item.update_attributes(params[:base_item])
	@base_item.draft!
	return render 'update_step2'
      else
	return render 'edit_step2'
      end
    end
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
<<<<<<< HEAD
      unless params[:base_item][:comment][:content].blank?
        current_user.comments.create params[:base_item][:comment]
      end
=======
      @base_item.item.change! if @base_item.item.new?
>>>>>>> 7a4de1b0972a310ac0c77454d644eac1621a46f5
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
