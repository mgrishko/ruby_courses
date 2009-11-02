module ArticlesHelper
	def show_status status
		status_id = status.nil? ? Article.default_status : status

		Article::STATUS[status_id]
	end
end
