class GtinFormatValidator < ActiveModel::EachValidator
  attr_reader :value

  def validate_each(record, attribute, value)
    return if value.blank?

    @value = value

    unless valid_gtin?
      record.errors[attribute] << I18n.t("errors.messages.invalid_gtin_format")
    end
  end

  private

  # Checks if gtin is in valid format.
  #
  # The last digit of a bar code number is a computer Check Digit
  # which makes sure the bar code is correctly composed.
  # See gtin calculator for more details http://www.gs1.org/barcodes/support/check_digit_calculator
  #
  # @return [Boolean] true if gtin is valid and false otherwise.
  def valid_gtin?
    return false unless [8, 12, 13, 14].include?(value.length)

    digits = value.rjust(18, "0").split(//).map(&:to_i)
    sum = digits.pop
    digits.each_with_index do |item, index|
      sum += index.even? ? item * 3 : item
    end

    sum % 10 == 0
  end
end
