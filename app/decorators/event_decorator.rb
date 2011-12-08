class EventDecorator < ApplicationDecorator
  decorates :event
  include CommonLinks
  
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
    if event.trackable_child_type.nil?
      I18n.t("#{event.trackable_type.pluralize.downcase}.events.#{event.type}", 
        user_name: event.user.full_name)
    else
      I18n.t("#{event.trackable_child_type.pluralize.downcase}.events.#{event.type}", 
        user_name: event.user.full_name)
    end
  end
  
  # Returns link to the trackable object page or the name of the event
  # if the current user can't read the object
  def trackable_link
    if h.can?(:read, event.trackable) && event.trackable
      h.link_to name, event.trackable
    else
      name
    end
  end
  
  # Returns the class name of the trackable object
  def trackable_name
    I18n.t("#{event.trackable_type.pluralize.downcase}.events.name")
  end
end