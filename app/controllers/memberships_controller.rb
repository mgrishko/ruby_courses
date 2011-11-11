class MembershipsController < ApplicationController
  load_and_authorize_resource
  
  def index
    @memberships = MembershipDecorator.decorate(current_account.memberships)
  end
end
