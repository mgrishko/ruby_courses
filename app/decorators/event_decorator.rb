class EventDecorator < ApplicationDecorator
  decorates :event
  
  # @return [String] event action label
  def action_label
    text = I18n.t("labels.#{event.eventable_type.downcase}.#{event.action_name}", scope: i18n_scope)

    css_class = case [event.eventable_type.downcase.to_sym, event.action_name.to_sym]
      when [:product, :update]
        "warning"
      when [:product, :create]
        "success"
      when [:product, :destroy]
        "important"
      when [:photo, :create], [:photo, :destroy]
        "notice"
    end

    h.content_tag :span, text, class: ["label", css_class].compact.join(" ")
  end

  # @return [String] user short name and event time
  def description
    time_ago = I18n.t("time_ago", time: h.time_ago_in_words(event.created_at))
    if event.created_at + 1.year < Time.now
      time_ago = "#{time_ago}, #{event.created_at.strftime("%b, %Y")}"
    elsif event.created_at + 1.day < Time.now
      time_ago = "#{time_ago}, #{event.created_at.strftime("%b %d")}"
    end

    "#{h.content_tag :span, "#{time_ago},"} #{event.user.short_name}".html_safe
  end
  
  # @return [String] link to the trackable object page or the name of the event
  #   if the current user can't read the object
  def trackable_link
    content = event.action_name == "destroy" ? h.content_tag(:span, event.name, class: "deleted") : event.name

    if event.trackable.nil?
      content
    else
      klass = "#{event.trackable_type.classify}Decorator".constantize
      opts = { content: content }
      unless event.eventable_type == event.trackable_type || event.action_name == "destroy"
        opts.merge!(anchor: event.eventable_id)
      end
      klass.decorate(event.trackable).trackable_link(opts)
    end
  end
end