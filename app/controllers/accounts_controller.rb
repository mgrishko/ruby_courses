class AccountsController < MainController
  before_filter :load_account
  authorize_resource

  def edit
    respond_with(@account)
  end

  def update
    @account.update_attributes(params[:account])
    respond_with(@account, location: edit_account_url(subdomain: @account.subdomain))
  end

private

  def load_account
    @account = current_account
  end
end
