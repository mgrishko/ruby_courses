require 'spec_helper'

describe Account do
  let(:account) { Fabricate(:account) }

  it { should validate_presence_of(:subdomain) }
  it { should validate_presence_of(:company_name) }
  it { should validate_presence_of(:country) }
  it { should validate_presence_of(:time_zone) }

  it { should allow_mass_assignment_of(:subdomain) }
  it { should allow_mass_assignment_of(:company_name) }
  it { should allow_mass_assignment_of(:country) }
  it { should allow_mass_assignment_of(:time_zone) }
  it { should allow_mass_assignment_of(:locale) }
  it { should_not allow_mass_assignment_of(:state) }

  it "should have and belong to many users" do
    user = account.users.build
    user.accounts.should include(account)
  end

  describe "state" do
    it "should be pending by default" do
      account.should be_pending
    end

    it "should be changed to active after activate event" do
      account.activate
      account.should be_active
    end
  end
end
