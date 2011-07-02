module SubscriptionResultsHelper
  def truncated_comment base_item, n=100
    comment = base_item.item.comments.last(:conditions => {:user_id => base_item.user_id})
    if comment
      if comment.content.size > n
        comment.content[0..n] + '...'
      else
        comment.content
      end
    else
      '&nbsp;'.html_safe
    end
  end
end

