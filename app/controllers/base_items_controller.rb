require 'zip/zip'
require 'zip/zipfilesystem'
class BaseItemsController < ApplicationController
  before_filter :require_user
  autocomplete :base_item, :brand, :full => true, :uniq => true, :use_limit => true
  autocomplete :base_item, :subbrand, :full => true, :uniq => true, :use_limit => true
  autocomplete :base_item, :functional, :full => true, :uniq => true, :use_limit => true
  autocomplete :base_item, :variant, :full => true, :uniq => true, :use_limit => true
  autocomplete :base_item, :item_description, :full => true, :uniq => true, :use_limit => true
  autocomplete :base_item, :manufacturer_gln, :full => true,
               :extra_data => [:manufacturer_name],
               :use_limit => true,
               :display_value => :manufacturer do
                 {:where =>{:user_id =>  current_user.id}}
               end
  autocomplete :base_item, :manufacturer_name, :full => true,
               :extra_data => [:manufacturer_gln],
               :use_limit => true,
               :display_value => :manufacturer do
                 {:where =>{:user_id =>  current_user.id}}
               end


  def index
    redirect_to :controller => "subscription_results" if current_user.retailer?
    BaseItem.per_page = 12
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
        @accepted_base_item = BaseItem.all(
          :conditions => ["item_id = ? AND sr.status = 'accepted' AND base_items.id < ? AND base_items.status = 'published'", @base_item.item_id,@base_item.id],
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
    @retailers = User.retailers
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
    @retailers = User.retailers
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

  # Create a draft version of base_item
  def draft
    @base_item = current_user.base_items.find params[:id]
    if @base_item.published?
      #make new base_item.tree
      new_base_item = BaseItem.new(@base_item.attributes)
      new_base_item.created_at = new_base_item.updated_at = nil
      new_base_item.state = 'change' #not new. This is version
      return render :text => new_base_item.errors.full_messages unless new_base_item.draft!
      new_base_item.save
      map_id = {}
      roots = @base_item.packaging_items.roots
      roots.reverse.each  do |root|
        pi = new_base_item.packaging_items.new(root.attributes)
        pi_attributes ={:user_id => current_user.id, :base_item_id => new_base_item.id}
        pi.update_attributes(pi_attributes)
        #old new
        map_id[root.id] = pi.id

        root.descendants.each do |d|
          pi = new_base_item.packaging_items.new(d.attributes)
          pi.update_attributes!(pi_attributes.merge({:parent_id => map_id[d.parent_id]}))
          map_id[d.id] = pi.id
        end

      end
      # receivers list
      @base_item.receivers.each do |r|
        Receiver.create(:base_item_id => new_base_item.id, :user_id => r.user_id)
      end
      #end
      #redirect_to :action => "show", :id => new_base_item.id
      redirect_to base_item_path(new_base_item)
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


  #export base_item or base_items
  #TODO: possible exception handling
  def export
    files ={}
    ids =  params['base_items'] ? params['base_items'][0..-1].split(',') : params[:id]
    @base_items = BaseItem.where(:id => ids)
    @forms = params[:forms]
    @name =""
    @prefix = "#{Rails.root}/tmp/xls/"
      @name += "#{ Time.now.strftime("%m%d%Y_%H%M")}_"
      @forms.each do |f|
        xls = generate_xls(@base_items, f, @name)
        xls.each_with_index do |xls_file,index|
          files["#{@name}_#{index}_#{f}.xls"] = xls_file
        end
      end

    if files.count == 1
      send_file files.first[1].path, :filename => files.first[0]
    else
      tmp = package_to_zip(files)
      send_file tmp.path, :filename => "#{@name}.zip"
    end
  end

  private

  def package_to_zip(files)
    tmp = Tempfile.new("zipfile_to_#{request.remote_ip}.zip")
    Zip::ZipOutputStream.open(tmp.path) do |zos|
      files.each do |name, content|
        zos.put_next_entry(name)
        zos.puts File.read(content.path)
      end
    end
    tmp
  end

  def generate_xls(bis, template, name)
    @base_items = bis
    str = render_to_string :template => 'base_items/attachment.xml', :layout => false
    xls = Xml2xls::convert(str, template, name)
  end

end

