require "spec_helper"

describe AccountMailer do
  let(:owner) { Fabricate.build(:user) }
  let(:account) { Fabricate.build(:account, owner: owner) }

  describe "activation email" do
    let(:email) { AccountMailer.activation_email(account) }

    it "delivers to the account owner email" do
      email.should deliver_to(owner.email)
    end
  end
end
