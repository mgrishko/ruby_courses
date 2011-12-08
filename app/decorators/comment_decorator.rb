class CommentDecorator < ApplicationDecorator
  decorates :comment

#  def destroy_link(opts = {})
#    if h.can?(:destroy, comment)
#      opts = (opts || {}).with_indifferent_access
#      opts.merge!(method: :delete, remote: true)
#      h.link_to(I18n.t("destroy", scope: scope),
#                h.send("#{comment.commentable.class.name.underscore}_comment_path",
#                       comment.commentable.id, comment.id), opts)
#    end
#  end
  
  def info
    "#{comment.user.full_name}, #{comment.created_at.strftime('%d %b %Y, %H:%M')}"
  end

  private

  def scope
    "comments.defaults"
  end
end

