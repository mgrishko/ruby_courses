require "spec_helper"

describe AccountMailer do
  let(:owner) { Fabricate.build(:user) }
  let(:account) { Fabricate.build(:account, owner: owner) }

  describe "activation email" do
    let(:email) { AccountMailer.activation_email(account) }

    it "delivers to the account owner email" do
      email.should deliver_to(owner.email)
    end

    it "should be delivered from GoodsMaster" do
      email.should be_delivered_from("#{Settings.project_name} <#{Settings.send_mail_from}>")
    end

    it "inserts subject message" do
      email.should have_subject("[#{account.subdomain}] Account for #{account.company_name} has been activated")
    end
  end
end
