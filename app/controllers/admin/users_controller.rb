class Admin::UsersController < Terbium::Controller::Base
  before_filter :require_admin

  index do
    field :gln
    field :name
    field :roles
  end

  form do
    field :gln
    field :name
    field :password
    field :password_confirmation
    field :roles, :fields=>[]
  end

end
