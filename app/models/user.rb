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
      return self.base_items.where(:status => "published").order('id desc').first.created_at.to_s(:db)
    else
      return '---'
    end
  end

  def all_fresh_base_items
    base_items.where(:status => 'published').order('id DESC')
  end

  def all_fresh_base_items_paginate page
    BaseItem.paginate_by_sql("select a.* from base_items as a where a.id = (select b.id from base_items b where a.item_id = b.item_id and b.status='published' and b.user_id = #{self.id} order by id desc limit 1) order by a.id desc", :page => page, :per_page => 10)
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

  def supplier?
    self.role == 'supplier'
  end

  def retailer?
    self.role == 'retailer'
  end

  def has_usual_subscription? item
    Subscription.where(:retailer_id => self.id, :supplier_id => item.user_id, :status => 'active', :specific => false).count() > 0
  end
end

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
#  is_admin          :boolean(1)
#  name              :string(255)
#  role              :string(255)
#

