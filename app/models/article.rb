require 'gtin_field_validations'

class Article < ActiveRecord::Base
  include FilterByUser
  has_many :packaging_items, :conditions => {:packaging_item_id => nil}
  belongs_to :user
  validates_is_gtin :gtin
  validates_presence_of :gtin
  validates_numericality_of :gtin
  validates_uniqueness_of :gtin, :scope => :user_id
  
  @@statuses = {
    :draft => 1, 
    :published => 2,
    :disabled => 3,
    :error => 4
  }

  @@status_messages = {
    :draft => 'Draft',
    :published => 'Published',
    :disabled => 'In progress',
    :error => 'Declined'
  }
  
  def set_default_status
    update_status self.class.default_status
  end
  
  
  def self.default_status
    :draft
  end
  
  def update_status id
    self.status = @@statuses[id]
  end

  def print_status
    @@status_messages[get_status]
  end

  def get_status
    @@statuses.index(status)
  end
  
  def status_disabled
    update_status :disabled
  end
  
  def status_enabled
    update_status :published
  end
  
  def self.fetch_and_approve
    MailOperations.fetch_emails_via_imap
    ArticleMailer.processed_data
  end

  def deliver_approve_email
    ArticleMailer.deliver_approve_email(self)
    update_status :disabled
  end

end
