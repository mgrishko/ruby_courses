class EventDecorator < ApplicationDecorator
  decorates :event
  include CommonLinks
  
  # Returns the date when the event occured
  def formatted_date
    if event.created_at + 1.day > DateTime.now
      h.time_ago_in_words(event.created_at) + " ago"
    else
      event.created_at.strftime("%b %d, %Y")
    end
  end
  
  # Returns the name of the user who raised the event
  def user_name
    event.user.full_name
  end
  
  # Returns event name
  def display_name
    I18n.t("#{event.trackable_type.pluralize.downcase}.defaults.#{event.type}")
  end 
  
  # Returns link to the trackable object page or display_name of the trackable object page
  def show_link
    trackable_class = "#{event.trackable_type}".constantize
    trackable_decorator_class = "#{event.trackable_type}Decorator".constantize
    trackable_object = trackable_class.find_trackable(event.trackable_id)
    trackable_decorator_object = trackable_decorator_class.new(trackable_object)
    trackable_decorator_object.show_link
  end
end