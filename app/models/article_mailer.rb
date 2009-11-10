class ArticleMailer < ActionMailer::Base
  @@processed_data = []

  def approve_email(article)
    recipients APP_CONFIG[:mail][:server][:email]
    from       APP_CONFIG[:mail][:client][:email]
    subject    "#{article.gtin}"
    sent_on    Time.now
    body       :article => article
    content_type 'text/xml'
  end

  def receive(email)
    if email.body.match(/([\d]+).*(yes|no)/)
      article_code = $1
      status = $2 == 'yes' ? :published : :error
      art = Article.find_by_gtin(article_code.to_i)
      unless art.nil?
        art.update_status status
        art.save
        
        @@processed_data.push(email)
      end
    end
  end

  def self.processed_data
    @@processed_data
  end
end
