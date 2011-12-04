class EventDecorator < ApplicationDecorator
  decorates :event
  include CommonLinks
  
  def formatted_date
    event.created_at.strftime("%b %d, %Y")
  end
  
  def user_name
    event.user.full_name
  end
  
  def display_name
    I18n.t("#{event.trackable_type.pluralize.downcase}.defaults.#{event.type}")
  end 
  
  def show_link
    if self.type?("destroyed")
      trackable_class = "#{event.trackable_type}".constantize
      trackable_decorator_class = "#{event.trackable_type}Decorator".constantize
      trackable_decorator = trackable_decorator_class.new(trackable_class.deleted.find(event.trackable_id))
      trackable_decorator.show_link
    else
      trackable_decorator = "#{event.trackable_type}Decorator".constantize.new(event.trackable)
      return trackable_decorator.show_link
    end
  end
end