require 'spec_helper'

describe Membership do
  let(:membership) { Fabricate(:membership) }

  it { should validate_presence_of(:role) }
  it { should allow_value("admin").for(:role) }
  it { should allow_value("editor").for(:role) }
  it { should allow_value("contributor").for(:role) }
  it { should allow_value("viewer").for(:role) }
  it { should_not allow_value("god").for(:role) }
  it { should allow_mass_assignment_of(:role) }

  it { should validate_presence_of(:user) }
  it { should allow_mass_assignment_of(:user) }

  describe "#role?" do
    it "returns true if with role" do
      membership.role = "admin"
      membership.should be_role(:admin)
    end

    it "returns false if with other role" do
      membership.role = "editor"
      membership.should_not be_role(:admin)
    end
  end

  describe "owner?" do
    it "returns true if owner" do
      membership.account.owner = membership.user
      membership.should be_owner
    end

    it "returns false if not owner" do
      membership.account.owner = Fabricate(:user)
      membership.should_not be_owner
    end
  end
end
