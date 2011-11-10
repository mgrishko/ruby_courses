# Make sure this require is after you require cucumber/rails/world.
#require 'email_spec' # add this line if you use spork
require 'email_spec/cucumber'


# Email-spec visits links in email only by path (request_uri). That is not what we want if we use subdomains.
# This is a monkey patch to use full url instead of path.
module EmailSpec
  module Helpers
    private
    def request_uri(link)
      link
    end
  end
end