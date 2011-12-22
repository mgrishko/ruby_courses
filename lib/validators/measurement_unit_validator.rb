require 'active_model'

module ActiveModel
  module Validations
    class MeasurementUnitValidator < ActiveModel::Validator
      attr_reader :record

      def validate(record)
        @record = record

        if (dimension_measure? && !valid_dimension_unit?) ||
            (weight_measure? && !valid_weight_unit?)
          record.errors[:value] << I18n.t("errors.messages.invalid_measure_unit", unit: record.unit)
        end
      end

      private

      def dimension_measure?
        %w(depth height width).include?(record.name)
      end

      def weight_measure?
        %w(gross_weight net_weight).include?(record.name)
      end

      def valid_dimension_unit?
        ["MM"].include?(record.unit)
      end

      def valid_weight_unit?
        ["GR"].include?(record.unit)
      end
    end
  end
end