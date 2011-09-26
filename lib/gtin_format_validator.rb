class GtinFormatValidator < ActiveModel::EachValidator
  def validate_each(object, attribute, value)
    unless valid_gtin? value
      object.errors[attribute] << (options[:message] || I18n.t('item.gtin_invalid'))
    end
  end

private

  def valid_gtin? gtin
    return false unless [8, 12, 13, 14].include?(gtin.length)
    digits = gtin.rjust(18, '0').split(//)
    check_digit = digits.pop.to_i
    digits.each_with_index do |item, index|
      check_digit += index.even? ? item.to_i * 3 : item.to_i
    end
    return check_digit % 10 == 0
  end
end
