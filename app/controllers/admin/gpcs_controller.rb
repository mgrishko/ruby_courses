class Admin::GpcsController < Terbium::Controller::Base
  before_filter :require_admin

  index do
    field :name
    field :code
  end

  form do
    field :name
    field :code
  end

end
