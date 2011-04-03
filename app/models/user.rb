class User < ActiveRecord::Base
  has_many :items
  has_many :base_items
  has_many :packaging_items
  has_many :subscriptions, :foreign_key => 'retailer_id'
  has_many :subscribers, :class_name => 'Subscription', :foreign_key => 'supplier_id'
  has_many :suppliers, :class_name => 'User', :through => :subscriptions
  has_many :retailers, :class_name => 'User', :through => :subscribers
  has_many :subscription_results, :through => :subscriptions
  has_many :comments
  has_many :clouds

  validates_uniqueness_of :gln
  acts_as_authentic do |a|
    a.validate_login_field = false
    a.validate_password_field = true
    a.validates_uniqueness_of_login_field_options = {
      :case_sensitive => true
    }
    a.login_field :gln
    a.disable_perishable_token_maintenance  true
    a.crypto_provider Authlogic::CryptoProviders::MD5
  end

  def fresh_base_items
    if self.base_items.count > 0
      return self.base_items.first(:order => 'created_at desc').created_at
    else
      return '---'
    end
  end

  def my_retailer_info(user_id)
    if self.retailers.find(:first, :conditions => ['retailer_id=?', user_id])
      return "Отписаться"
    else
      return "Подписаться"
    end
  end
end
