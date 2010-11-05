class Admin::CountriesController < Terbium::Controller::Base
  before_filter :require_admin

  index do
    field :code
    field :description
  end

  form do
    field :code
    field :description
  end

end
