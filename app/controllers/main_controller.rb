class MainController < ApplicationController
  before_filter :authenticate_user!
  before_filter :validate_account_membership!

  private

  # Responds with 401 Unauthorized status code if current user does not a member of current account.
  def validate_account_membership!
    head :unauthorized unless current_membership?
  end
end