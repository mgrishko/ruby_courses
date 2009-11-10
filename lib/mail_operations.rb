require 'net/pop'
require 'net/imap'

class MailOperations
  def self.fetch_new_emails
    new_emails = []
    pop = Net::POP3.new(APP_CONFIG[:mail][:client][:pop_address], APP_CONFIG[:mail][:client][:pop_port])
    pop.enable_ssl
    pop.start(
      APP_CONFIG[:mail][:client][:email],
      APP_CONFIG[:mail][:client][:password]
    ) 

    unless pop.mails.empty?  
      pop.each_mail do |mail|  
        email = TMail::Mail.parse(mail.pop)
        new_emails.push(email)
      end
    end
    new_emails
  end

  def self.fetch_emails_via_imap
    imap = Net::IMAP.new(APP_CONFIG[:mail][:client][:imap_address], APP_CONFIG[:mail][:client][:imap_port], true)
    imap.login(APP_CONFIG[:mail][:client][:email], APP_CONFIG[:mail][:client][:password])
    imap.select('INBOX')
    imap.search(['NOT', 'DELETED']).each do |message_id|
      msg = imap.fetch(message_id,'RFC822')[0].attr['RFC822']
      ArticleMailer.receive(msg)
      #imap.store(message_id, "+FLAGS", [:Deleted])
    end
    imap.logout 
    imap.disconnect
  end
  
end
