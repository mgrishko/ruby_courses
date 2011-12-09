# test/test_helper.rb
require 'simplecov'

# features/support/env.rb
require 'simplecov'

# .simplecov
SimpleCov.start 'rails' do
  # any custom configs like groups and filters can be here at a central place
  add_group 'Decorators', 'app/decorators'
  add_group 'Uploaders', 'app/uploaders'
end
