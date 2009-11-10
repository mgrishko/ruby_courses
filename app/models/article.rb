class Article < ActiveRecord::Base
  include GtinFieldValidations
  validates_gtin
  has_many :packaging_items, :conditions => {:packaging_item_id => nil}
  belongs_to :user
  
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
    mails = MailOperations.fetch_new_emails
    processed = []
    mails.each do |mail|
      article_code, new_status = MailOperations.get_articlecode_and_status(mail)
      
      unless article_code.nil?
      
        art = Article.find_by_gtin(article_code, :select => 'id, status' )
        unless art.nil?
          art.update_status new_status
          art.save
          
          # save emails for reports
          processed.push(mail)
        end
      end
    end
    processed
  end

  def deliver_approve_email
    ArticleMailer.deliver_approve_email(self)
    update_status :disabled
  end

end
