module SubscriptionResultsHelper
  def truncated_comment base_item, n=100
    comment = base_item.comments.last
    if comment
      if comment.content.size > n
        comment.content[0..n] + '...'
      else
        comment.content
      end
    else
      'n/a'
    end
  end
end
