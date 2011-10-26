# Require fabricators which are placed not in a standard place
Dir[Rails.root.join("spec/fabricators/**/*.rb")].each {|f| require f}