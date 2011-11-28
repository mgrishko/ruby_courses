class MembershipsController < MainController
  load_and_authorize_resource :through => :current_account

  def index
    @memberships = MembershipDecorator.decorate(@memberships)
    respond_with(@memberships)
  end

  # GET /memberships/new
  # GET /memberships/new.xml
  def new
    #@membership = current_account.memberships.new loaded by CanCan
    @membership = MembershipDecorator.decorate(@membership)
    respond_with(@membership)
  end

  def edit
    @membership = MembershipDecorator.decorate(@membership)
    respond_with(@membership)
  end

  # POST /memberships
  # POST /memberships.xml
  def create
    #@membership = current_account.memberships.new loaded by CanCan
    @membership.invited_by = current_user
    @membership.user = User.new(params[:membership][:user_attributes])
    @membership.save
    @membership = MembershipDecorator.decorate(@membership)

    # ToDo We should move this to the model
    set_already_invited_error

    respond_with(@membership) do |format|
      if @membership.errors.empty?
        format.html { redirect_to memberships_path }
      else
        format.html { render action: :new }
      end
    end
  end

  def update
    @membership.update_attributes(params[:membership])
    @membership = MembershipDecorator.decorate(@membership)
    respond_with(@membership, location: :memberships)
  end

  def destroy
    @membership.destroy
    respond_with(@membership)
  end

  private

  def set_already_invited_error
    @membership.user.errors.add(:email, @membership.errors[:already_invited].first)
  end
end
