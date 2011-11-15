module ApplicationHelper
  # Sets content for title in head and for body header.
  #
  # @param [String] page_title page title
  # @param [Hash] options optional. if options[:body] == true or does not present it sets content for body title.
  def title(page_title, options = {})
    set_body_title = options[:body].nil? ? true : options[:body]
    if set_body_title
      body_title = content_tag(:h2, page_title.to_s)
      content_for(:body_title, body_title.to_s)
      content_for(:head_title, page_title.to_s)
    else
      content_for(:head_title, page_title.to_s)
    end
  end
end
