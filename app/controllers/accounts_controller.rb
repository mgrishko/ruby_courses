class AccountsController < MainController
  before_filter :load_account
  authorize_resource

  #def index
    #@accounts = Account.all

    #respond_to do |format|
      #format.html # index.html.erb
      #format.json { render json: @accounts }
    #end
  #end

  def edit
    respond_with(@account)
  end

  def update
    @account.update_attributes(params[:account])
    respond_with(@account, location: :edit_account)
  end

private

  def load_account
    @account = current_account
  end
end
