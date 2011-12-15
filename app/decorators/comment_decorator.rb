class CommentDecorator < ApplicationDecorator
  decorates :comment
  
  def show_link(opts = {})
    commentable_decorator_class = "#{comment.commentable.class.name}Decorator".constantize
    decorator = commentable_decorator_class.decorate(comment.commentable)
    decorator.show_link(opts.merge(anchor: comment.id))
  end
  
  def info
    "#{comment.user.full_name}, #{comment.created_at.strftime('%d %b %Y, %H:%M')}"
  end

  # Returns event description if the comment is linked to an event.
  def system_info
    h.simple_format(EventDecorator.decorate(event).description) unless comment.event.nil?
  end
end

