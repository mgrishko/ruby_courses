module GtinFieldValidations
  def self.included(base)
    base.extend(ClassMethods)
    base.class.extend(GtinFieldValidations)
  end

  def is_valid_gtin
    s = gtin.to_s.rjust 8, '0'
    if [8, *(12..14)].grep(s.size).size != 0
      tmp = s.split '' 
      checknum = tmp.pop.to_i

      sum = 0
      i = true
      tmp.reverse.each do |n|
        sum += n.to_i * (i ? 3 : 1)
        i = !i
      end

      if checknum != (10 - (sum % 10)).to_i
        errors.add(:gtin, "checksum is not correct ")
      else 
        true
      end

    else
      errors.add(:gtin, 'length is not valid')
    end
  end


  module ClassMethods
    def validates_gtin
      validates_presence_of :gtin
      validates_uniqueness_of :gtin, :scope => :user_id
      validate :is_valid_gtin
    end

  end
end
