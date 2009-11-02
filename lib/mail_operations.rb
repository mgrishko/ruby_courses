require 'net/pop'

class MailOperations
	def self.fetch_new_emails
		new_emails = []
		Net::POP3.enable_ssl(OpenSSL::SSL::VERIFY_NONE)
		Net::POP3.start(
			APP_CONFIG[:mail][:client][:pop_address],
			APP_CONFIG[:mail][:client][:pop_port],
			APP_CONFIG[:mail][:client][:email],
			APP_CONFIG[:mail][:client][:password]
		) do |pop|  
			if pop.mails.empty?  
				puts 'No mail.'  
			else
				pop.each_mail do |mail|  
				email = TMail::Mail.parse(mail.pop)
					new_emails.push(email)
				end
			end
		end
		new_emails
	end
	
	def self.get_articlecode_and_status email
		if email.from[0].match(APP_CONFIG[:mail][:server][:email])
			if email.subject.match(/([\d]+)/)
				article_id = $1
				if email.body.match(/yes/i)
					[article_id, Article::PUBLISHED]
				else
					[article_id, Article::DISABLED]
				end
			end
		end
	end
	
end
