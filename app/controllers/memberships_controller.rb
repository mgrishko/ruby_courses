class MembershipsController < MainController
  load_and_authorize_resource :through => :current_account
  
  def index
    @memberships = MembershipDecorator.decorate(@memberships)
  end
  
  def edit
    
  end
  
  def update
    @membership.attributes = params[:membership]
    if @membership.save
      respond_with(@membership) do |format|
        format.html { redirect_to memberships_path }
      end
    else
      render :edit
    end
=begin
    if @membership.save
      if @membership.user != current_user || @membership.role?(:admin)
        respond_with(@membership) do |format|
          format.html { redirect_to memberships_path }
        end
      else
        redirect_to root_path
      end
    else
      render :edit
    end
=end
  end
  
  def destroy
    #@membership = current_account.memberships.find(params[:id])
    @membership.destroy
    respond_with @membership
  end
end
