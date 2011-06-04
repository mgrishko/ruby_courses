module Terbium
  module CoreExt
  end
end

Array.class_eval do
  include Terbium::CoreExt::Array
end

Kernel.class_eval do
  def swallow_nil
    yield
  rescue NoMethodError
    nil
  end
end

class String
  def singular?
    self.singularize == self
  end

  def plural?
    self.pluralize == self
  end
end

class Symbol
  def singular?
    to_s.singularize == to_s
  end

  def plural?
    to_s.pluralize == to_s
  end
end


ActionView::Helpers::FormTagHelper.class_eval do

  alias_method :origin_token_tag, :token_tag

  def token_tag
    controller.class.terbium_admin? && controller.translates? ?
      origin_token_tag + tag(:input, :type => "hidden", :name => 'translation', :value => controller.translation) :
      origin_token_tag
  end

end

ActionDispatch::Routing::RouteSet.class_eval do

  alias_method :original_clear!, :clear!

  def clear!
    @admined_controllers = {}
    original_clear!
  end

  def admined_controllers prefix, controller = nil
    @admined_controllers ||= {}
    @admined_controllers[prefix] ||= []
    if controller
      @admined_controllers[prefix].push(controller)
    else
      @admined_controllers[prefix]
    end
  end

end

ActionDispatch::Routing::Mapper.class_eval do

  alias_method :original_resource, :resource
  alias_method :original_resources, :resources

  def resource *resources, &block
    administrator_resource(*resources, &block) || original_resource(*resources, &block)
  end

  def resources *resources, &block
    administrator_resources(*resources, &block) || original_resources(*resources, &block)
  end

  def administrator_resource(*resources, &block)
    options = resources.extract_options!

    if apply_common_behavior_for(:resource, resources, options, &block)
      return self
    end

    resource_name = resources.pop
    resource = ActionDispatch::Routing::Mapper::Resources::SingletonResource.new(resource_name, options)
    controller = "#{[@scope[:module], resource.controller].compact.join("/")}_controller".classify.constantize rescue nil

    return if controller.nil? || (controller && !swallow_nil{controller.terbium_admin?})

    @scope[:ancestors] ||= []
    @scope[:children] ||= []

    resource_scope(resource) do
      siblings = @scope[:children].dup
      @scope[:children] = []
      @scope[:ancestors].push resource.singular.to_s

      yield if block_given?

      @scope[:ancestors].pop
      Rails.application.routes.admined_controllers(@scope[:module], controller) if @scope[:ancestors].empty?
      options = {:resources => {:ancestors => @scope[:ancestors].dup.push(resource_name.to_s.pluralize), :children => @scope[:children].dup}}
      siblings.push resource.singular.to_s
      @scope[:children] = siblings

      collection_scope do
        post :create, options
        controller.route_collection_actions.each do |(method, action)|
          send action, method, options
        end
      end

      new_scope do
        get :new, options
      end

      member_scope  do
        get    :edit, options
        get    :show, options
        put    :update, options
        delete :destroy, options
        controller.route_member_actions.each do |(method, action)|
          send action, method, options
        end
      end

    end

    self
  end

  def administrator_resources(*resources, &block)
    options = resources.extract_options!

    if apply_common_behavior_for(:resources, resources, options, &block)
      return self
    end

    resource_name = resources.pop
    resource = ActionDispatch::Routing::Mapper::Resources::Resource.new(resource_name, options)
    controller = "#{[@scope[:module], resource.controller].compact.join("/")}_controller".classify.constantize rescue nil

    return if controller.nil? || (controller && !swallow_nil{controller.terbium_admin?})

    @scope[:ancestors] ||= []
    @scope[:children] ||= []

    resource_scope(resource) do
      siblings = @scope[:children].dup
      @scope[:children] = []
      @scope[:ancestors].push resource.plural.to_s

      yield if block_given?

      @scope[:ancestors].pop
      Rails.application.routes.admined_controllers(@scope[:module], controller) if @scope[:ancestors].empty?
      options = {:resources => {:ancestors => @scope[:ancestors].dup.push(resource_name.to_s.pluralize), :children => @scope[:children].dup}}
      siblings.push resource.plural.to_s
      @scope[:children] = siblings


      collection_scope do
        get  :index, options
        post :create, options
        controller.route_collection_actions.each do |(method, action)|
          send action, method, options
        end
      end

      new_scope do
        get :new, options
      end

      member_scope  do
        get    :edit, options
        get    :show, options
        put    :update, options
        delete :destroy, options
        controller.route_member_actions.each do |(method, action)|
          send action, method, options
        end
      end
    end

    self
  end
  def collection_scope
    with_scope_level(:collection) do
              scope(parent_resource.collection_scope) do
                yield
              end
            end
  end
  def new_scope
    with_scope_level(:new) do
              scope(parent_resource.new_scope(action_path(:new))) do
                yield
              end
            end
  end

  def member_scope
            with_scope_level(:member) do
              scope(parent_resource.member_scope) do
                yield
              end
            end
          end
end

