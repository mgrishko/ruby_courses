module ApplicationHelper
  def title(page_title, options = {})
    if options[:body] == true
      body_title = content_tag(:h1, page_title.to_s)
      content_for(:body_title, body_title.to_s)
      content_for(:head_title, page_title.to_s)
    else
      content_for(:head_title, page_title.to_s)
    end
  end
end
