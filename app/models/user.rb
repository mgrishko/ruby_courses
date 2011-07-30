# encoding = utf-8

# == Schema Information
#
# Table name: users
#
#  id                :integer(4)      not null, primary key
#  gln               :integer(4)
#  pw_hash           :string(255)
#  persistence_token :string(255)
#  created_at        :datetime
#  updated_at        :datetime
#  name              :string(255)
#  roles_mask        :integer(4)
#  description       :text
#  contacts          :text
#

class User < ActiveRecord::Base
  has_many :items
  has_many :base_items
  has_many :packaging_items
  has_many :subscriptions, :foreign_key => 'retailer_id'
  has_many :subscribers, :class_name => 'Subscription', :foreign_key => 'supplier_id', :conditions => ["subscriptions.status = ?", "active"]
  has_many :suppliers, :class_name => 'User', :through => :subscriptions
  has_many :retailers, :class_name => 'User', :through => :subscribers
  has_many :subscription_results, :through => :subscriptions
  has_many :comments
  has_many :clouds
  has_many :user_tags
  has_many :tags , :through => :clouds
  has_many :receivers
  has_many :events
  has_many :item_comments, :class_name => 'Comment', :through => :items
  has_many :item_retailer_attributes, :class_name => 'RetailerAttribute', :through => :items
  has_many :base_item_subscription_results, :class_name => 'SubscriptionResult', :through => :base_items
  has_many :clouded_items , :class_name => 'Item', :through => :clouds

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


  ROLES = %w[admin retailer local_supplier global_supplier]

  scope :retailers,
    where("roles_mask & #{2**ROLES.index('retailer')} != 0")
  scope :local_suppliers,
    where("roles_mask & #{2**ROLES.index('local_supplier')} != 0")
  scope :global_suppliers,
    where("roles_mask & #{2**ROLES.index('global_supplier')} != 0")
  scope :suppliers,
    where("roles_mask & #{2**ROLES.index('global_supplier') | 2**ROLES.index('local_supplier')} != 0")

  def fresh_base_items
    if self.base_items.count > 0
      return self.base_items.where(:status => "published").order('id desc').first.created_at.to_s(:db)
    else
      return '---'
    end
  end

  def all_fresh_base_items
    base_items.where(:status => 'published').order('id DESC')
  end

  def all_fresh_base_items_paginate page, options = {:per_page => 10}
    BaseItem.last_published_by(self).reverse.paginate :page => page, :per_page => options[:per_page]
  end

  def count_fresh_base_items
    base_items.where(:status => 'published').count()
  end

  def my_retailer_info(user_id)
    if self.retailers.find(:first, :conditions => ['retailer_id=?', user_id])
      return "Отписаться"
    else
      return "Подписаться"
    end
  end

  def my_retailer_flag(user_id)
    if self.retailers.find(:first, :conditions => ['retailer_id=?', user_id])
      return true
    else
      return nil
    end
  end

  def roles=(roles)
    self.roles_mask = (roles & ROLES).map { |r| 2**ROLES.index(r) }.sum if roles
  end

  def roles
    ROLES.reject do |r|
      ((roles_mask || 0) & 2**ROLES.index(r)).zero?
    end
  end

  def is?(role)
    roles.include?(role.to_s)
  end

  def supplier?
    (%w[local_supplier global_supplier] & roles).any?
  end

  def retailer?
    roles.include? 'retailer'
  end

  def is_admin?
    is? 'admin'
  end

  def has_usual_subscription? item
    self.subscriptions.usual.active.where(:supplier_id => item.user_id).any?
  end
end

