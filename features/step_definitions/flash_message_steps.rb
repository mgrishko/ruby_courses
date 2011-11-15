Then /^(?:[^\s]* )should see (.*) message "([^"]*)"$/ do |flash_class, message|
  page.find(".alert-message.#{flash_class} > p", :text => message)
end
