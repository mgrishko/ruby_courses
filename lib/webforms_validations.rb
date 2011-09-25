module WebformsValidations

  def validates_number_length_of attribute, max_length, options={}
    if options[:step]
      validates_numericality_of attribute, :greater_than => 0, :less_than_or_equal_to => 10**max_length - 1, :only_integer => true, :allow_nil => options[:allow_nil], :if => options[:step]
    else
      validates_numericality_of attribute, :greater_than => 0, :less_than_or_equal_to => 10**max_length - 1, :only_integer => true, :allow_nil => options[:allow_nil]
    end
  end

  def validates_gln attribute, *step
    if step
      validates_length_of attribute, :is => 13, :if => step
    else
      validates_length_of attribute, :is => 13
    end
  end

  def validates_gtin *attr_names
    configuration = {
      :on => :save,
      :message => I18n.t('item.gtin_invalid')
    }

    configuration.update(attr_names.extract_options!)

    validates_each(attr_names, configuration) do |record, attr_name, value|
      record.errors.add(attr_name, configuration[:message]) unless valid_gtin? value
    end
  end

  protected

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
