# encoding = utf-8
# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base

  @@model = nil
  helper :all # include all helpers, all the time
  protect_from_forgery :except => [:status, :instantstatus] # See ActionController::RequestForgeryProtection for details
  before_filter :link_model_with_auth_user, :set_user_language
  filter_parameter_logging :password, :password_confirmation

  helper_method :current_user_session, :current_user

  private
    def current_user_session
      return @current_user_session if defined?(@current_user_session)
      @current_user_session = UserSession.find
    end

    def current_user
      return @current_user if defined?(@current_user)
      @current_user = current_user_session ? current_user_session.user : User.new
    end

    def require_user
      unless current_user.id
        store_location
        flash[:notice] = t 'login.require_user' #"Пожалуйста войдите под своим аккаунтом для доступа к этой странице"
        redirect_to login_url
        return false
      end
    end

    def require_no_user
      if current_user.id
        store_location
        flash[:notice] = t 'login.require_no_user' #"Пожалуйста выйдите со своего аккаунта для доступа к этой странице"
        redirect_to root_url
        return false
      end
    end

    def require_admin
      if require_user.nil? && !current_user.is_admin
        flash[:notice] = t 'login.require_admin' #"Только администратор имеет право доступа к этой странице"
        redirect_to :controller => :user_sessions, :action => :login
        redirect_to root_url
        return false
      end
    end

    def store_location
      session[:return_to] = request.request_uri
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

    def get_bi_filters current_user, supplier=nil, all_suppliers=nil
      if current_user.supplier? # /base_items/:id
	@clouds = current_user.clouds.find(:all, :select => "tag_id, count(*) as q", :group=>"tag_id") #ok
	@receivers = BaseItem.get_receivers current_user
      else
	if all_suppliers
	  @clouds = Cloud.get_clouds current_user, supplier, all_suppliers
	else
	  @clouds = Cloud.get_clouds current_user, supplier
	end
      end
      @brands = BaseItem.get_brands current_user, supplier, all_suppliers
      @manufacturers = BaseItem.get_manufacturers current_user, supplier, all_suppliers
      @functionals = BaseItem.get_functionals current_user, supplier, all_suppliers
    end

    def set_user_language
      I18n.locale = 'en'
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

