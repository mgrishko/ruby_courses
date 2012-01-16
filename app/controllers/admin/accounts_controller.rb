class Admin::AccountsController < Admin::BaseController

  # GET /admin/accounts
  # GET /admin/accounts.json
  def index
    @accounts = AccountDecorator.all
    respond_with(@accounts)
  end

  # GET /admin/accounts/1
  # GET /admin/accounts/1.json
  def show
    @account = AccountDecorator.find(params[:id])
    respond_with(@account)
  end

  # GET /admin/accounts/1/activate
  # GET /admin/accounts/1/activate.json
  def activate
    account = Account.find(params[:id])
    if account.activate
      # ToDo Refactor to use AccountDrapper
      AccountMailer.activation_email(account).deliver

      flash.now[:notice] = t('flash.accounts.activate.notice')
    else
      flash.now[:alert] = t('flash.accounts.activate.alert')
    end

    @account = AccountDecorator.decorate(account)

    respond_with(@account) do |format|
      format.html { render :show }
    end
  end
  
  # GET /admin/accounts/1/login_as_owner
  # GET /admin/accounts/1/login_as_owner.json
  def login_as_owner
    @account = Account.find(params[:id])
    sign_in(:user, @account.owner)
    redirect_to home_url(subdomain: @account.subdomain)
  end
end
