class CommentDecorator < ApplicationDecorator
  decorates :comment

  def destroy_link(opts = {})
    if h.can?(:destroy, comment)
      opts = (opts || {}).with_indifferent_access
      opts.merge!(method: :delete, remote: true)
      h.link_to(I18n.t("destroy", scope: scope),
                h.send("#{comment.commentable.class.name.underscore}_comment_path",
                       comment.commentable.id, comment.id), opts)
    end
  end
  
  def display_name
    h.truncate(comment.body, length: 50)
  end
  
  def show_link
    if !comment.destroyed? && h.can?(:read, comment.commentable)
      commentable_decorator = "#{commentable.class.name}Decorator".constantize.new(comment.commentable)
      return commentable_decorator.show_link(text: display_name)
    else
      return display_name
    end
  end

  private

  def scope
    "comments.defaults"
  end
end