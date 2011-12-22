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
    I18n.t("events.#{event.eventable_type.pluralize.downcase}.#{event.action_name}",
      user_name: event.user.full_name)
  end
  
  # Returns link to the trackable object page or the name of the event
  # if the current user can't read the object
  def trackable_link
    return name unless event.trackable.present? && h.can?(:read, event.trackable)
      
    if event.eventable_type == event.trackable_type
      # if event is logged for the trackable object, then find it by id
      eventable_class = "#{event.eventable_type}".constantize
      eventable_object = eventable_class.where("_id" => event.eventable_id).first
    else
      # if event is logged for an embedded object of the trackable,
      # then find it in the embedded collection in the trackable
      eventable_object = "#{event.eventable_type}".constantize.send(
        :find_by_id_and_embedded_in, event.eventable_id, event.trackable)
    end
    
    return name if eventable_object.nil?
      
    eventable_decorator = "#{event.eventable_type}Decorator".constantize.send(:new, eventable_object)
    eventable_decorator.show_link text: event.name
  end
  
  # Returns the class name of the trackable object
  def trackable_name
    I18n.t("events.#{event.trackable_type.pluralize.downcase}.name")
  end
end