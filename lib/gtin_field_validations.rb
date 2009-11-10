module GtinFieldValidations
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def validates_gtin
      validates_presence_of :gtin
      validates_uniqueness_of :gtin, :scope => :user_id
    end
  end
end
