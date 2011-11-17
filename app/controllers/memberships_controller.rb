class MembershipsController < MainController
  load_and_authorize_resource :through => :current_account
  
  def index
    @memberships = MembershipDecorator.decorate(@memberships)
    respond_with(@memberships)
  end
  
  def edit
    @membership = MembershipDecorator.decorate(@membership)
    respond_with(@membership)
  end
  
  def update
    @membership.update_attributes(params[:membership])
    
    respond_with(@membership) do |format|
      if @membership.save
        format.html { redirect_to memberships_path }
      else
        format.html { render action: :edit }
      end
    end
  end
  
  def destroy
    @membership.destroy
    respond_with(@membership)
  end
end
