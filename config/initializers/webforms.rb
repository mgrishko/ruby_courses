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

class Array
  def to_ids
    map{|obj| obj.id}
  end
end

EXPORT_FORMS = ['7continent', 'auchan', 'general', 'globus', 'lenta']

