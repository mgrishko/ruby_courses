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
    if @account.update_attributes(params[:account])
      flash[:notice] = "Account was successfully updated."
      redirect_to edit_account_url
    else
      render 'edit'
    end
  end

private

  def load_account
    @account = current_account
  end
end
