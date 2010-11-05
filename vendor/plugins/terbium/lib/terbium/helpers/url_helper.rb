module Terbium
  module Helpers
    module UrlHelper

      def self.included base
        base.class_eval do
          helper_method *InstanceMethods.instance_methods

          include InstanceMethods
        end
      end

      module InstanceMethods

        def route_prefix
          @route_prefix ||= self.class.to_s.underscore.split('/')[0]
        end

        def resources_path *args
          options = args.extract_options!
          polymorphic_path(args + [route_prefix] + resource_ancestors_records + [resource], options)
        end

        def resource_path suggest = nil, *args
          options = args.extract_options!
          polymorphic_path(args + [route_prefix] + resource_ancestors_records + [plural? ? (suggest || record) : resource], options)
        end

        def edit_resource_path suggest = nil, *args
          options = args.extract_options!
          edit_polymorphic_path(args + [route_prefix] + resource_ancestors_records + [plural? ? (suggest || record) : resource], options)
        end

        def new_resource_path *args
          options = args.extract_options!
          new_polymorphic_path(args + [route_prefix] + resource_ancestors_records + [resource.singularize], options)
        end

        def resource_child_path record, child, *args
          options = args.extract_options!
          polymorphic_path(args + [route_prefix] + resource_ancestors_records + [record, child], options)
        end

      end

    end
  end
end
