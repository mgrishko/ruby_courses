class Article < ActiveRecord::Base
  has_many :packaging_items
	before_create :set_default_status
	
	DRAFT = 1
	PUBLISHED = 2
	DISABLED = 3
	STATUS = {DRAFT => 'Draft', PUBLISHED => 'Published', DISABLED => 'Disabled'}
	
	def set_default_status
		update_status Article.default_status
	end
	
	
	def self.default_status
		DRAFT
	end
	
	def update_status id
		self.status = id
	end
	
	def status_disabled
		update_status DISABLED
	end
	
	def status_enabled
		update_status PUBLISHED
	end
	
	def self.fetch_and_approve(type)
		case type
			when :emails
				mails = MailOperations.fetch_new_emails
				processed = []
				mails.each do |mail|
					article_code, new_status = MailOperations.get_articlecode_and_status(mail)
					
					unless article_code.nil?
					
						art = Article.find_by_record_code(article_code, :select => 'id, status' )
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
	end

end
