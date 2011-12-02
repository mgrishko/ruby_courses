class ApplicationDecorator < Draper::Base
  
  # Returns a formatted date
  def format_date(date)
    return date.strftime("%b %d, %Y")
  end
end