class MembershipsController < ApplicationController
  load_and_authorize_resource :through => :current_account
  
  def index
    @memberships = MembershipDecorator.decorate(@memberships)
  end
  
  def destroy
    @membership = current_account.memberships.find(params[:id])
    @membership.destroy
    respond_with @membership
  end
end
