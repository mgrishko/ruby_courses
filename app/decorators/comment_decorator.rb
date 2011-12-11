class CommentDecorator < ApplicationDecorator
  decorates :comment
  
  def show_link(opts = {})
    opts_text = opts.delete(:text)
    path = h.send("#{comment.commentable.class.name.downcase}_path", 
      comment.commentable.id, anchor: comment.id)
    h.link_to opts_text, path
  end
  
  def info
    "#{comment.user.full_name}, #{comment.created_at.strftime('%d %b %Y, %H:%M')}"
  end

  # Returns event description if the comment is linked to an event.
  def system_info
    h.simple_format(EventDecorator.decorate(event).description) unless comment.event.nil?
  end

  private

  def scope
    "comments.defaults"
  end
end

