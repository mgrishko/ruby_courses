class Admin::ProfilesController < Admin::BaseController
  before_filter :load_admin

  def edit
    respond_with(@admin)
  end

  def update
    @admin.update_attributes(params[:admin])
    sign_in :admin, @admin, bypass: true
    respond_with(@admin, location: edit_admin_profile_path(@admin, subdomain: Settings.app_subdomain))
  end

  private

  def load_admin
    @admin = current_admin
  end
end
