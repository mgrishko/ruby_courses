module Terbium
  module Controller
    module Mutate

      def self.included base
        base.class_eval do
          extend SingletoneMethods
        end
      end

      module SingletoneMethods

        def acts_as_terbium
          before_filter :process_filters

          layout 'terbium'

          include InstanceMethods
          #include Terbium::Helpers::MiscHelper
          include Terbium::Helpers::ObjectsHelper
          include Terbium::Helpers::UrlHelper
          extend ClassMethods

          helper_method :model_name, :boolean_fields, :resource_session
        end

        def terbium_admin?
          false
        end

      end

      module InstanceMethods

        def helpers
          @helpers ||= "#{route_prefix.classify}::#{controller_class_name}".constantize.helpers
        end

        def model_name
          self.class.model_name
        end

        def resource_session
          postfix = params[:action] =~ /associated_/ ? params[:action] : ''
          name = "#{model_name}#{postfix}".to_sym
          session[:resources] = {} unless session[:resources]
          session[:resources][name] = {} unless session[:resources][name]
          session[:resources][name][:boolean] = {} unless session[:resources][name][:boolean]
          session[:resources][name]
        end

        def render_action action
          result = "terbium/#{action}.html.erb"
          view_paths.each do |path|
            result = File.join(route_prefix, controller_name, "#{action}.html.erb") if File.exists?(File.join(path, route_prefix, controller_name, "#{action}.html.erb"))
          end
          render result
        end

        def process_filters
          if params[:order] && (params[:order].blank? || index_fields.map(&:order).include?(params[:order].split(' ')[0]))
            resource_session[:order] = params[:order]
            resource_session.delete(:order) if params[:order].blank?
          end
          if params[:query]
            resource_session[:query] = params[:query].strip
          end
          if params[:boolean]
            params[:boolean].each do |(field, value)|
              resource_session[:boolean][field] = value if boolean_fields.map(&:query_column).include?(field)
              resource_session[:boolean].delete(field) if value.blank?
            end
          end
        end

        def boolean_filters
          resource_session[:boolean].map do |(field, value)|
            value == 'nil' ? "#{field} is null" : "#{field} = '#{value}'"
          end.join(' and ')
        end

        def searchable_fields fields
          @searchable_fields ||= fields.map { |f| f if ['text', 'string', 'integer', 'decimal', 'float'].include? f.type.to_s }.compact
        end

        def boolean_fields
          @boolean_fields ||= index_fields.map { |f| f if ['boolean'].include? f.type.to_s }.compact
        end

      end

      module ClassMethods

        def model_name
          @model_name ||= terbium_config.model || controller_name.singularize
        end

        def terbium_admin?
          true
        end

      end

    end
  end
end
