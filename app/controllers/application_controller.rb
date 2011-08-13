# encoding = utf-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  @@model = nil
  helper :all # include all helpers, all the time
  protect_from_forgery :except => [:status, :instantstatus] # See ActionController::RequestForgeryProtection for details
  before_filter :set_locale
  before_filter :set_hostname
  before_filter :link_model_with_auth_user
  before_filter :browser_compatible?

  helper_method :current_user_session, :current_user

  rescue_from CanCan::AccessDenied do |exception|
    render_404(exception)
  end

  def render_404(exception = nil)
    if exception
      logger.info "ApplicationController@#{__LINE__} Rendering 404 with exception: #{exception.message}"
    end

    respond_to do |format|
      format.html { render :file => "#{Rails.root}/public/404_#{I18n.locale}.html", :status => :not_found, :layout => false }
      format.xml  { head :not_found }
      format.any  { head :not_found }
    end
  end

  private

  def set_locale
    if logged_in? && params[:locale] && current_user.locale != params[:locale]
      current_user.update_attribute(:locale ,params[:locale])
    end

    I18n.locale = session[:locale] =
      if current_user and current_user.locale and
          I18n.available_locales.include? current_user.locale.to_sym
        current_user.locale
      elsif params[:locale] and
          I18n.available_locales.include? params[:locale].to_sym
        params[:locale]
      elsif session[:locale] and
          I18n.available_locales.include? session[:locale].to_sym
        session[:locale]
      else
        preferred_language
      end

    @text_direction = RTL_LANGS.include?(I18n.locale) ? 'rtl' : 'ltr'
    logger.info "ApplicationController@#{__LINE__}#set_locale locale is #{I18n.locale.inspect} user is #{(!current_user || current_user.new_record?) ? '_guest_' : ("#{current_user.name}" + "(#{current_user.id})")}"
    @other_locales = []
    if request.get?
      query_parameters = params.dup
      I18n.available_locales.reject do |l|
        l == I18n.locale
      end.each do |l|
        @other_locales << query_parameters.merge(:locale => l)
      end
    end
    logger.debug "ApplicationController@#{__LINE__}#set_locale #{@other_locales.inspect}" if logger.debug?
  end

  def user_preferred_languages
    request.headers['Accept-Language'].split(',').collect do |l|
      l += ';q=1.0' unless l =~ /;q=\d+\.\d+$/
      l.split(';q=')
    end.sort do |x,y|
      raise "Not correctly formatted" unless x.first =~ /^[a-z\-]+$/i
      y.last.to_f <=> x.last.to_f
    end.collect do |l|
      l.first.downcase.gsub(/-[a-z]+$/i) { |x| x.upcase }
    end
  rescue # Just rescue anything if the browser messed up badly.
    []
  end

  def preferred_language
    (user_preferred_languages & I18n.available_locales.map(&:to_s)).first || I18n.default_locale
  end

  def self.current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def self.current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session ? current_user_session.user : User.new
  end

  def current_user_session
    return @current_user_session if defined?(@current_user_session)
    @current_user_session = UserSession.find
  end

  def current_user
    return @current_user if defined?(@current_user)
    @current_user = current_user_session && current_user_session.record || User.new
  end

  def logged_in?
    current_user_session && current_user_session.record
  end

  def require_user
    unless current_user.id
      store_location
      flash[:notice] = t('flash.account_login')
      redirect_to login_url
      return false
    end
  end

  def require_no_user
    if current_user.id
      store_location
      flash[:notice] = t('flash.account_logout')
      redirect_to root_url
      return false
    end
  end

  def require_admin
    if require_user.nil? && !current_user.is_admin?
      flash[:notice] = t('flash.account_admin')
      redirect_to :controller => :user_sessions, :action => :login
      redirect_to root_url
      return false
    end
  end

  def store_location
    session[:return_to] = request.fullpath
  end

  def redirect_back_or_default(default)
    redirect_to(session[:return_to] || default)
    session[:return_to] = nil
  end

  def find_item
    return @@model.find(params[:id])
  end

  def link_model_with_auth_user
    if @@model && @@model.respond_to?(:set_auth_user)
      @@model.set_auth_user current_user
    end
  end

  def get_filters_data_for_base_items
    @clouds = current_user.clouds.find(:all, :select => "tag_id, count(*) as q", :group=>"tag_id")
    @brands = BaseItem.get_brands current_user
    @manufacturers = BaseItem.get_manufacturers current_user
    #functional name
    @functionals = BaseItem.get_functionals current_user
  end

  def get_filters_data_for_base_items_conditions retailer, supplier=nil
    @clouds = Cloud.get_clouds retailer, supplier
    @brands = BaseItem.get_brands supplier ? supplier : retailer
    @manufacturers = BaseItem.get_manufacturers supplier ? supplier : retailer
    #functional name
    @functionals = BaseItem.get_functionals supplier ? supplier : retailer
  end

  def get_bi_filters(user, supplier=nil, all_suppliers=nil)
    if user.supplier? # /base_items/:id
      @clouds = user.clouds.find(:all, :select => "tag_id, count(*) as q", :group=>"tag_id") #ok
      @receivers = BaseItem.get_receivers user
    else
      if all_suppliers
        @clouds = Cloud.get_clouds user, supplier, all_suppliers
      else
        @clouds = Cloud.get_clouds user, supplier
      end
    end
    @brands = BaseItem.get_brands user, supplier, all_suppliers
    @manufacturers = BaseItem.get_manufacturers user, supplier, all_suppliers
    @functionals = BaseItem.get_functionals user, supplier, all_suppliers
  end

  def browser_compatible?
    result  = request.env['HTTP_USER_AGENT']
    browser_compatible = false
    if result =~ /Safari/
      unless result =~ /Chrome/
        version = result.split('Version/')[1].split(' ').first.split('.').first
        browser_compatible = version.to_i > 3
      else
        version = result.split('Chrome/')[1].split(' ').first.split('.').first
         browser_compatible =  version.to_i > 8
      end
    elsif result =~ /Firefox/
     version = result.split('Firefox/')[1].split('.').first
     browser_compatible =  version.to_i > 2
    end
    @supported_browser = browser_compatible
  end

  def set_hostname
    @hostname = request.host
    port = request.port
    @hostname << ":#{port}" if port != 80
    ActionMailer::Base.default_url_options =
      {:host => @hostname, :locale => I18n.locale}
    logger.debug "ApplicationController@#{__LINE__}#set_hostname #{@hostname.inspect}" if logger.debug?
  end

end

class TrueClass
  def to_char
    'Y'
  end
end

class FalseClass
  def to_char
    'N'
  end
end

