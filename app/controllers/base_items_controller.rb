class BaseItemsController < ApplicationController
  before_filter :require_user

  def index
    redirect_to :controller => "subscription_results" if current_user.retailer?

    @base_items = BaseItem.get_base_items :user_id => current_user.id,
                                          :manufacturer_name => params[:manufacturer_name],
                                          :functional => params[:functional],
                                          :brand => params[:brand],
                                          :tag => params[:tag],
					  :receiver => params[:receiver],
					  :search => params[:search],
					  :page => params[:page]
    get_bi_filters current_user
  end

  def show
    if params[:view]
      @view_only = true;
      @base_item = BaseItem.find(params[:id])
      @packaging_items = @base_item.packaging_items
      @subscription_result = SubscriptionResult.find(params[:subscription_result_id]) if params[:subscription_result_id]
      if current_user.retailer? && @subscription_result
        @accepted_base_item = BaseItem.all(:conditions => ["item_id = ? AND sr.status = 'accepted' AND base_items.id < ? AND base_items.status = 'published'", @base_item.item_id,@base_item.id],
                                            :joins => 'JOIN subscription_results sr ON base_items.id = sr.base_item_id',
                                            :order => 'base_items.id DESC').first
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
    @retailers = User.find(:all, :conditions => {:role => 'retailer'})
    @clouds = Cloud.find(:all, :conditions => {:user_id => current_user.id, :item_id => @base_item.item.id})
  end

  def new
    if current_user.retailer?
      redirect_to :action => 'index'
    end
    session[:base_item_params] = {}
    session.delete :base_item_step if session[:base_item_step]
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
    @retailers = User.find(:all, :conditions => {:role => 'retailer'})
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
		@base_item.state = 'add' #new status of bi
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
      #@base_item.item.update_attributes(:private => params[:base_item][:private])
      @base_item.update_attributes(:private => params[:base_item][:private])


      unless params[:base_item][:comment][:content].blank?
        current_user.comments.create params[:base_item][:comment]
      end

      if @base_item.has_difference_between_old?
	@base_item.publish!
	@base_item.item.change! if @base_item.item.add?
	# add new event into log
	Event.log(current_user, @base_item)
	# /log
      end
    end
    redirect_to base_items_url
  end

  def draft
    @base_item = current_user.base_items.find params[:id]
    if @base_item.published?
      #make new base_item.tree
      n = BaseItem.new(@base_item.attributes)
      n.created_at = n.updated_at = nil
      n.state = 'change' #not new. This is version
      return render :text => n.errors.full_messages unless n.draft!
      n.save
      map_id = {}
      roots = @base_item.packaging_items.roots
      roots.each  do |root|
    	  pi = n.packaging_items.new(root.attributes)
      	pi.user = current_user
      	pi.base_item_id = n.id
      	pi.save

      	#old new
      	map_id[root.id] = pi.id

      	root.descendants.each do |d|
      	  pi = n.packaging_items.new(d.attributes)
      	  pi.user = current_user
      	  pi.base_item_id = n.id
      	  pi.parent_id = map_id[d.parent_id]
      	  pi.save!
      	  map_id[d.id] = pi.id
      	end

      end
      # receivers list
      @base_item.receivers.each do |r|
      	Receiver.create(:base_item_id => n.id, :user_id => r.user_id)
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

  def classifier
    #@groups = Group.find(:all)
    respond_to do |format|
      format.js
    end
  end

  #def auto_complete_for_base_item_gpc_name
  #  @gpcs = Gpc.find(:all, :conditions => ["LOWER(name) LIKE ?", "%#{params[:base_item][:gpc_name].downcase}%"])
  #  render :inline => "<%= auto_complete_result(@gpcs, 'name') %>"
  #end

  def auto_complete_for_base_item_brand
    @base_items = BaseItem.find(:all, :conditions => ["LOWER(brand) LIKE ?", "%#{params[:base_item][:brand].downcase}%"])
    render :inline => "<%= auto_complete_result(@base_items, 'brand') %>"
  end

  def auto_complete_for_base_item_subbrand
    @base_items = BaseItem.find(:all, :conditions => ["LOWER(subbrand) LIKE ?", "%#{params[:base_item][:subbrand].downcase}%"])
    render :inline => "<%= auto_complete_result(@base_items, 'subbrand') %>"
  end

  def auto_complete_for_base_item_functional
    @base_items = BaseItem.find(:all, :conditions => ["LOWER(functional) LIKE ?", "%#{params[:base_item][:functional].downcase}%"])
    render :inline => "<%= auto_complete_result(@base_items, 'functional') %>"
  end

  def auto_complete_for_base_item_item_description
    @base_items = BaseItem.find(:all, :conditions => ["LOWER(item_description) LIKE ?", "%#{params[:base_item][:item_description].downcase}%"])
    render :inline => "<%= auto_complete_result(@base_items, 'item_description') %>"
  end

  def auto_complete_for_base_item_manufacturer_gln
     @base_items = BaseItem.find(:all, :conditions => ["manufacturer_gln LIKE ?", "%#{params[:base_item][:manufacturer_gln]}%"])
     render :partial => 'autocomplete_manufacturer'
  end

  def auto_complete_for_base_item_manufacturer_name
     @base_items = BaseItem.find(:all, :conditions => ["LOWER(manufacturer_name) LIKE ?", "%#{params[:base_item][:manufacturer_name].downcase}%"])
     render :partial => 'autocomplete_manufacturer'
  end

  private

  def generate_attachment
    f = File.new("#{RECORDS_OUT_DIR}/#{@base_item.id}.xml", 'w')
    f.write(render_to_string :template => 'base_items/attachment.xml', :layout => false)
    f.close
  end

end

