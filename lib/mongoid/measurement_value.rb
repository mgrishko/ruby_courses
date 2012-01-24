module Mongoid
  module MeasurementValue

    # This module defines measure values fields and validations for Mongoid documents.

    extend ActiveSupport::Concern

    module ClassMethods

      #   class Content
      #     include Mongoid::Document
      #     include Mongoid::MeasureValue
      #     measurement_value_field :value
      #   end
      #
      def measurement_value_field(*args)
        args.each do |arg|
          field arg, type: BigDecimal
          validates arg, numericality: { greater_than: 0 }, allow_blank: true,
                    length: 0..16, format: /^\d{0,15}(\.\d{1,14})?$/

          define_method("#{arg}") do
            value = attributes[arg.to_s]
            return nil if value.blank?
            value = BigDecimal.new(value)
            int = value.to_i
            int == 0 || value % int > 0 ? value : int
          end
        end
      end

     end
  end
end