module Terbium
  module Helpers
    module ObjectsHelper

      def self.included base
        base.class_eval do
          helper_method *InstanceMethods.instance_methods

          include InstanceMethods
        end
      end

      module InstanceMethods

        def resource_ancestors
          params[:resources][:ancestors][0..-2]
        end

        def resource_ancestors_records
          unless @resource_ancestors_records
            @resource_ancestors_records = []
            resource_ancestors.each_with_index do |ancestor, index|
              if ancestor.plural?
                @resource_ancestors_records[index] = ancestor.classify.constantize.find(params["#{ancestor.singularize}_id"])
              else
                @resource_ancestors_records[index] = @resource_ancestors_records[index - 1].send(ancestor)
              end
            end
          end
          @resource_ancestors_records
        end

        def resource_parent
          @resource_parent ||= resource_ancestors.last
        end

        def resource_parent_record
          @resource_parent_record ||= resource_ancestors_records.last
        end

        def resource_parent?
          !!resource_parent
        end

        def plural?
          resource.plural?
        end

        def resource_children
          params[:resources][:children]
        end

        def resource
          @resource ||= params[:resources][:ancestors].last
        end

        def target
          @target ||= resource_parent? ? resource_parent_record.send(resource) : model
        end

        def model
          @model ||= model_name.singularize.classify.constantize
        end

        def record
          @record || instance_variable_get("@#{resource.singularize}")
        end

        def translates?
          model.respond_to?(:translates?) && model.translates?
        end

        def translation
          param = params[model_name] ? params[model_name][:translation] || params[:translation] : params[:translation]
          param && I18n.available_locales.include?(param.to_sym) ? param.to_sym : I18n.default_locale
        end

      end

    end
  end
end
