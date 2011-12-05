class CommentDecorator < ApplicationDecorator
  decorates :comment

  def info
    "#{comment.user.full_name}, #{comment.created_at.strftime('%d %b %Y, %H:%M')}"
  end

end
