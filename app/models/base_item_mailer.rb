class BaseItemMailer < ActionMailer::Base
  #@@processed_data = []

  def approve_email(base_item)
    recipients 'mrostotski@gmail.com'
    from       APP_CONFIG[:mail][:client][:email]
    subject    "#{base_item.gtin}"
    sent_on    Time.now
    body       'testing attachment'
    content_type 'text/plain'
    attachment :content_type => "text/xml",
      :filename => "pg_#{Time.now.strftime("%Y%m%d%H%M%S")}#{rand(1000)}.xml",
      :body => File.read(File.join(RECORDS_OUT_DIR, "#{base_item.id}.xml"))
  end

  #def receive(email)
    #if email.body.match(/([\d]+).*(yes|no)/)
      #base_item_code = $1
      #status = $2 == 'yes' ? :published : :error
      #bi = base_item.find_by_gtin(base_item_code.to_i)
      #unless art.nil?
        #bi.update_status status
        #bi.save

        #@@processed_data.push(email)
      #end
    #end
  #end

  #def self.processed_data
    #@@processed_data
  #end

end
