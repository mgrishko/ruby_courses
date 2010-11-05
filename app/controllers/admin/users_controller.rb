class Admin::UsersController < Terbium::Controller::Base
  before_filter :require_admin

  index do
    field :gln
    field :is_admin
  end

  form do
    field :gln
    field :password
    field :password_confirmation
    field :is_admin
  end

end
