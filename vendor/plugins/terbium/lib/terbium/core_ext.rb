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

ActionController::Routing::Route.class_eval do

  alias_method :origin_append_query_string, :append_query_string
  alias_method :origin_freeze, :freeze
  #alias_method :origin_generate, :generate

=begin
  def generate *args
    translation = args.first.delete(:translation)
    url = origin_generate *args
    if translation && I18n.available_locales.include?(translation.to_sym) && translation.to_sym != I18n.default_locale
      url = "/#{translation}#{url}"
    end
    url
  end
=end

  def append_query_string(path, hash, query_keys = nil)
    return nil unless path
    translation = hash.delete(:translation)
    path = "#{path}_#{translation}" if path != '/' && translation && I18n.available_locales.include?(translation.to_sym) && translation.to_sym != I18n.default_locale
    origin_append_query_string(path, hash, query_keys)
  end

  def freeze
    segs unless frozen?
    origin_freeze
  end

  def segs
    @segs ||= segments.last.is_optional ? segments[0..-2].join : segments.join
  end

end

ActionController::Resources.class_eval do

  remove_const :INHERITABLE_OPTIONS if const_defined?(:INHERITABLE_OPTIONS)
  const_set :INHERITABLE_OPTIONS, [:namespace, :shallow, :ancestors]

  alias_method :origin_map_resource, :map_resource
  alias_method :origin_map_singleton_resource, :map_singleton_resource
  alias_method :origin_action_options_for, :action_options_for

  def action_options_for(action, resource, method = nil, resource_options = {})
    options = origin_action_options_for action, resource, method, resource_options
    controller = "#{resource.controller}_controller".classify.constantize rescue nil
    if controller && controller.terbium_admin?
      options[:resources] ||= {}
      options[:resources][:ancestors] = resource.options[:ancestors]
      options[:resources][:children] = resource.options[:children]
    end
    options
  end

  def map_resource(entities, options = {}, &block)
    origin_map_resource entities, append_terbium_routes(entities, options, false, &block), &block
  end

  def map_singleton_resource(entities, options = {}, &block)
    origin_map_singleton_resource entities, append_terbium_routes(entities, options, true, &block), &block
  end

  def append_terbium_routes entities, options, singleton, &block
    controller = "#{options[:namespace]}#{options[:controller] || entities.to_s.pluralize}_controller".classify.constantize rescue nil
    if controller && controller.terbium_admin?
      options = Marshal.load(Marshal.dump(options))
      options = controller.append_route_options(options)
      options[:ancestors] ||= []
      options[:ancestors] << (singleton ? controller.controller_name.singularize : controller.controller_name)
      options[:children] = []
      if block_given?
        harvester = ActionController::ResourceHarvester.new(options)
        block.call(harvester)
        options[:children] = harvester.children
      end
    end
    options
  end

end

module ActionController
  class ResourceHarvester
    attr_accessor :children

    def initialize options = {}
      @options = options
      @children = []
    end

    def resource *entities, &block
      collect_children entities, true
    end

    def resources *entities, &block
      collect_children entities, false
    end

    def collect_children entities, singleton
      options = entities.extract_options!
      options.reverse_merge! @options
      entities.each do |entity|
        controller = "#{options[:namespace]}#{options[:controller] || entity.to_s.pluralize}_controller".classify.constantize rescue nil
        @children << (singleton ? controller.controller_name.singularize : controller.controller_name) if controller && controller.terbium_admin?
      end
    end

    def method_missing method, *arguments, &block
    end

  end
end
