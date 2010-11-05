module Terbium
  module Helpers
    module MiscHelper

      def self.included base
        base.class_eval do
          helper_method *InstanceMethods.instance_methods

          include InstanceMethods
        end
      end

      module InstanceMethods

        def default_url_options options = {}
          {:translation => translation} if translates? && !options.key?(:translation)
        end

      end

    end
  end
end
