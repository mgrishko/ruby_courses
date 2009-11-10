
class ArticleMailer < ActionMailer::Base
  def approve_email(article)
    recipients APP_CONFIG[:mail][:server][:email]
    from       APP_CONFIG[:mail][:client][:email]
    subject    "#{article.gtin}"
    sent_on    Time.now
    body       :article => article
    content_type 'text/xml'
  end
end
