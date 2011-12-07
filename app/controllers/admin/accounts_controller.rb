class Admin::AccountsController < Admin::BaseController
  layout "admin"

  # GET /admin/accounts
  # GET /admin/accounts.json
  def index
    @accounts = Admin::AccountDecorator.all
    respond_with(@accounts)
  end

  # GET /admin/accounts/1
  # GET /admin/accounts/1.json
  def show
    @account = Admin::AccountDecorator.find(params[:id])
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

    @account = Admin::AccountDecorator.decorate(account)

    respond_with(@account) do |format|
      format.html { render :show }
    end
  end
end
