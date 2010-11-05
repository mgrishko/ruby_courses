class TerbiumControllerGenerator < Rails::Generator::NamedBase

  attr_reader :model_name, :model, :controller_name, :prefix

  def initialize(runtime_args, runtime_options = {})
    super

    name = runtime_args[0].include?('/') ? runtime_args[0].split('/')[1] : runtime_args[0]
    @prefix = runtime_args[0].include?('/') ? runtime_args[0].split('/')[0] : 'admin'
    @model_name = name.classify
    @controller_name = "#{model_name.pluralize}Controller"
    @model = model_name.constantize rescue nil
  end

  def manifest
    record do |m|
      m.directory("app/controllers/#{@prefix}")
      m.template('controller.rb', "app/controllers/#{@prefix}/#{controller_name.underscore}.rb")
    end
  end

end
