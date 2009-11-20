require 'gtin_field_validations'

class Article < ActiveRecord::Base
  @@in_dir = nil
  @@out_dir = nil
  include FilterByUser
  has_many :packaging_items, :conditions => {:packaging_item_id => nil}
  belongs_to :user
  #GTIN
  validates_is_gtin :gtin
  validates_presence_of :gtin
  validates_numericality_of :gtin, :less_than => 10 ** 14, :greater_than_or_equal_to => (10 ** (14 - 1))
  validates_uniqueness_of :gtin, :scope => :user_id

  #Length
  validates_length_of :plu_description, :maximum => 12
  validates_length_of :item_name_long_en, :maximum => 30
  validates_length_of :manufacturer_name, :maximum => 35
  validates_length_of :item_name_long_ru, :maximum => 30

  #Numericality
  #XXX greater_than_or_equal doesn't work
  validates_numericality_of :internal_item_id
  validates_numericality_of :manufacturer_gln, :less_than => (10 ** 13), :greater_than_or_equal_to => (10 ** (13 -1))
  validates_numericality_of :content, :greater_than_or_equal_to => 0.001, :less_than => 10 ** 9
  validates_numericality_of :content_uom
  validates_numericality_of :gross_weight, :less_than => 10 ** 7, :greater_than => 0
  validates_numericality_of :vat
  validates_numericality_of :gpc
  validates_numericality_of :country_of_origin
  validates_numericality_of :minimum_durability_from_arrival, :less_than => 10 ** 4, :greater_than => 0
  validates_numericality_of :packaging_type
  validates_numericality_of :height, :less_than => 10 ** 5, :greater_than => 0
  validates_numericality_of :depth,  :less_than => 10 ** 5, :greater_than => 0
  validates_numericality_of :width,  :less_than => 10 ** 5, :greater_than => 0


  
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

  def publish_xml
    f = File.new("#{out_dir}/#{id}.xml", 'w')
    f.syswrite("test")
    update_status :disabled
    save
  end

  def check_for_xml_response
    fname = "#{in_dir}/#{id}.xml"
    if File::exists?(fname) && File::readable?(fname)

    end
  end

  def after_initalize
    unless self.new_record?
      check_for_xml_response
    end
  end

  def out_dir
    @@out_dir || RECORDS_OUT_DIR
  end

  def out_dir=(val)
    @@out_dir = val
  end

  def in_dir
    @@in_dir || RECORDS_IN_DIR
  end
  
  def in_dir=(val)
    @@in_dir = val
  end
end
