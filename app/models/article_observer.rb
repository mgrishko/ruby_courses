class ArticleObserver < ActiveRecord::Observer
	def after_create(article)
		ArticleMailer.deliver_approve_email(article)
	end
end 