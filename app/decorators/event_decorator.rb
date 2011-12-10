class EventDecorator < ApplicationDecorator
  decorates :event
  
  # Returns the date when the event occured
  def date
    if event.created_at + 1.day > DateTime.now
      I18n.t("events.defaults.time_ago", time: h.time_ago_in_words(event.created_at))
    else
      event.created_at.strftime("%b %d, %Y")
    end
  end
  
  # Returns event description and user name
  def description
    I18n.t("#{event.eventable_type.pluralize.downcase}.events.#{event.action_name}", 
      user_name: event.user.full_name)
  end
  
  # Returns link to the trackable object page or the name of the event
  # if the current user can't read the object
  def trackable_link
    if event.trackable.present? && h.can?(:read, event.trackable)
      eventable_object = "#{event.eventable_type}".constantize.send(:super_find, event.eventable_id, event.trackable)
      if eventable_object.nil?
        name
      else
        eventable_decorator = "#{event.eventable_type}Decorator".constantize.send(:new, eventable_object)
        eventable_decorator.show_link text: event.name
      end
    else
      name
    end
  end
  
  # Returns the class name of the trackable object
  def trackable_name
    I18n.t("#{event.trackable_type.pluralize.downcase}.events.name")
  end
end