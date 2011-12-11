class Admin::AdminsController < ApplicationController
  prepend_before_filter :authenticate_admin!
  before_filter :load_admin
  layout "admin"

  def edit
    respond_with(@admin)
  end

  def update
    @admin.update_attributes(params[:admin])
    respond_with(@admin, location: edit_admin_path)
  end

  private

  def load_admin
    @admin = current_admin
  end
end
