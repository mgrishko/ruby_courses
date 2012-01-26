class Users::AccountsController < ApplicationController
  before_filter :authenticate_user!

  layout "clean"

  # GET /signup/accounts
  # GET /signup/accounts.json
  def index
    @accounts = current_user.accounts.all
    respond_with(@accounts)
  end

  # GET /signup/accounts/new
  # GET /signup/accounts/new.json
  def new
    @account = current_user.accounts.new
    respond_with(@account)
  end

  # POST /signup/accounts
  # POST /signup/accounts.json
  def create
    @account = current_user.accounts.new(params[:account])
    @account.save

    respond_with(@account) do |format|
      if @account.errors.empty?
        format.html { redirect_to signup_acknowledgement_url(subdomain: Settings.app_subdomain),
                                  notice: t("devise.registrations.signed_up") }
      else
        format.html { render action: :new }
      end
    end
  end
end
