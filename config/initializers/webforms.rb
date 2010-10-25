ActiveRecord::Base.class_eval do
  extend WebformsValidations
end

Kernel.class_eval do
  def swallow_nil
    yield
  rescue NoMethodError
    nil
  end
end
