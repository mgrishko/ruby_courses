class MembershipsController < ApplicationController
  load_and_authorize_resource :through => :current_account
  
  def index
    @memberships = MembershipDecorator.decorate(@memberships)
  end
  
  def edit
    
  end
  
  def update
    @membership.attributes = params[:membership]
    if @membership.save
      if @membership.user != current_user || @membership.role?(:admin)
        respond_with @membership
      else
        redirect_to root_path
      end
    else
      render :edit
    end
  end
  
  def destroy
    #@membership = current_account.memberships.find(params[:id])
    @membership.destroy
    respond_with @membership
  end
end
