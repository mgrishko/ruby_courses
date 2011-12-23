# .simplecov
if ENV["COVERAGE"]
  SimpleCov.start 'rails' do
    # any custom configs like groups and filters can be here at a central place
    add_group 'Decorators', 'app/decorators'
    add_group 'Uploaders', 'app/uploaders'
  end
end