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
  it { should_not allow_mass_assignment_of(:user_id) }

  it "should validate associated user" do
    user = Fabricate.build(:user, email: "invalid")
    user.should_not be_valid
    membership = Fabricate.build(:membership, user: user)
    membership.should_not be_valid
  end

  it { should_not validate_presence_of(:invited_by) }
  it { should_not allow_mass_assignment_of(:invited_by) }

  it { should_not validate_presence_of(:invitation_note) }
  it { should allow_mass_assignment_of(:invitation_note) }
  it { should ensure_length_of(:invitation_note).is_at_most(1000) }

  it "should belong to user" do
    user = Fabricate(:user)
    membership = Fabricate(:membership, user: user)
    membership.user.should eql(user)
  end

  it "should belong to invited_by" do
    invited_user = Fabricate(:user)
    membership = Fabricate(:membership, invited_by: invited_user)
    membership.invited_by.should eql(invited_user)
  end
  
  it "should have current membership" do
    user = Fabricate(:user)
    membership = Fabricate(:membership, user: user)
    Membership.current = membership
    Membership.current.should == membership
  end

  describe "callbacks" do
    context "before validation on create" do

      before(:each) { @membership = Fabricate.build(:membership) }

      it "runs #find_or_initialize_user" do
        @membership.should_receive(:find_or_initialize_user)
        @membership.run_callbacks(:validation)
      end
    end

    context "before validation on update" do
      before(:each) { @membership = Fabricate(:membership) }

      it "runs #find_or_initialize_user" do
        @membership.should_not_receive(:find_or_initialize_user)
        @membership.run_callbacks(:validation)
      end
    end

    context "after create" do
      context "user is not an account owner" do
        before(:each) { @membership = Fabricate.build(:membership) }

        it "runs #send_membership_invitation" do
          @membership.should_receive(:send_membership_invitation)
          @membership.run_callbacks(:create)
        end
      end

      context "user is an account owner" do
        before(:each) do
          account = Fabricate.build(:account)
          @membership = account.memberships.build user: account.owner
        end

        it "does not run #send_membership_invitation" do
          @membership.should_not_receive(:send_membership_invitation)
          @membership.run_callbacks(:create)
        end
      end
    end
  end

  describe "#find_or_initialize_user" do
    before(:each) do
      @user = Fabricate.build(:user, email: "invited@email.com", first_name: "Invited")
      @account = Fabricate(:account, owner: Fabricate(:user, time_zone: "Auckland", locale: "de"))
      @membership = Fabricate.build(:membership, user: @user, account: @account)
    end

    context "when user with email exist" do
      before(:each) do
        @existing_user = Fabricate(:user, email: @user.email, first_name: "Existing")
      end

      it "it associates with existing user" do
        @membership.send(:find_or_initialize_user)
        @membership.user.should eql(@existing_user)
      end

      it "does not change user name" do
        @membership.send(:find_or_initialize_user)
        @membership.user.first_name.should == "Existing"
      end
    end

    context "when user with email does not exist" do
      it "runs user password generation" do
        @membership.user.should_receive(:generate_password!)
        @membership.send(:find_or_initialize_user)
      end

      it "sets user locale to account locale" do
        @membership.send(:find_or_initialize_user)
        @membership.user.locale.should == "de"
      end

      it "sets user time zone to account time zone" do
        @membership.send(:find_or_initialize_user)
        @membership.user.time_zone.should == "Auckland"
      end

      context "when user is not valid" do
        before(:each) { @user.email = "invalid" }

        it "does not create user" do
          @membership.send(:find_or_initialize_user)
          @membership.user.should be_new_record
        end
      end
    end
  end

  describe "#send_membership_invitation" do
    before(:each) do
      user = Fabricate(:user, email: "invited@email.com", first_name: "Invited")
      @membership = Fabricate(:membership, user: user)
    end

    it "sends invitation email" do
      message = mock(Mail::Message)
      MembershipMailer.should_receive(:invitation_email).with(@membership).and_return(message)
      message.should_receive(:deliver)
      @membership.send(:send_membership_invitation)
    end
  end

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
