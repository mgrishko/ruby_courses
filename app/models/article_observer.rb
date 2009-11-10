class ArticleObserver < ActiveRecord::Observer
  def after_create(article)
    article.deliver_approve_email
  end
end 
