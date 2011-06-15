module EventsHelper
  def event_url(current_user, event)
    content = if event.content.is_a?(SubscriptionResult)
      sr_description event.content
    else
      event.content.get_description
    end
    content_tag(:a, content, :title => event.content.get_title, :href => event.content.get_url(current_user))
  end
  def sr_description sr
    content_tag(:div, nil, :class => "fleft sr-status sr-#{sr.status}",:title => "#{sr.status_for_title}")+
    content_tag(:div, "&nbsp;".html_safe + sr.get_description,:class => 'fleft')
  end
end

