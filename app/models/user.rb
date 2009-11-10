class User < ActiveRecord::Base
  has_many :articles
  has_many :packaging_items
  validates_uniqueness_of :gln
  acts_as_authentic do |a|
    a.validate_login_field = false
    a.validate_password_field = true
    a.validates_uniqueness_of_login_field_options = {
      :case_sensitive => false
    }
    a.login_field :gln
    a.disable_perishable_token_maintenance  true
    a.crypto_provider Authlogic::CryptoProviders::MD5
  end
end
