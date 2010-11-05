require File.join(File.dirname(__FILE__), 'lib/terbium')
require File.join(File.dirname(__FILE__), "/lib/paginator")

ActionView::Base.send :include, Paginator::ViewHelpers

ActionController::Dispatcher.middleware.use Terbium::Rack::TranslationsOverlay
ActionController::Dispatcher.middleware.use Terbium::Rack::StaticOverlay, File.join(File.dirname(__FILE__), 'public')

ActionView::Helpers::FormBuilder.class_eval do
  include Terbium::FormBuilder
end

ActionController::Base.class_eval do
  include Terbium::Controller::Mutate
end

ActionView::Base.class_eval do
  include Terbium::CoreExt::ActionView::Base
end

ActiveRecord::Base.class_eval do
  include Terbium::CoreExt::ActiveRecord::Base
end
