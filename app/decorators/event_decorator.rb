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
    I18n.t("#{event.trackable.class.name.pluralize.downcase}.defaults.#{event.type}")
  end 
  
  def show_link
    trackable_decorator = "#{event.trackable.class.name}Decorator".constantize.new(event.trackable)
    trackable_decorator.show_link
  end
end