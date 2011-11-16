require 'spec_helper'

describe MembershipsController do
  login :user

  before(:each) do
    @account = Fabricate(:account_with_memberships)
    @account_decorator = Admin::AccountDecorator.decorate(@account)
  end
end
