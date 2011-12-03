class EventDecorator < ApplicationDecorator
  decorates :event
  include CommonLinks
  
  def formated_date
    event.created_at.strftime("%b %d, %Y")
  end
  
  def user_name
    event.user.full_name
  end
  
  def display_name
    I18n.t("#{event.object.class.name.pluralize.downcase}.defaults.#{event.type}")
  end 
  
  def show_link
    object_decorator = "#{event.object.class.name}Decorator".constantize.new(event.object)
    object_decorator.show_link
  end
end