class CommentDecorator < ApplicationDecorator
  decorates :comment

  # @return [String] comment details info: when and who created comment and action type.
  def details
    time_ago = I18n.t("time_ago", time: h.time_ago_in_words(comment.created_at))
    if comment.created_at + 1.year < Time.now
      time_ago = "#{time_ago}, #{comment.created_at.strftime("%b, %Y")}"
    elsif comment.created_at + 1.day < Time.now
      time_ago = "#{time_ago}, #{comment.created_at.strftime("%b %d")}"
    end

    h.content_tag :span, "#{time_ago}, #{comment.user.full_name}"
  end

end

