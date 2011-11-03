Then /^(?:[^\s]* )should see (.*) message "([^"]*)"$/ do |flash_class, message|
  page.find("p.flash.#{flash_class}", :text => message)
end
