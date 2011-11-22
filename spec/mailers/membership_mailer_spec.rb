require "spec_helper"

describe MembershipMailer do
  let(:user) { Fabricate.build(:user) }
  let(:invited_by) { Fabricate.build(:user) }
  let(:membership) { Fabricate.build(:membership, user: user, invited_by: invited_by) }

  describe "invitation email" do
    let(:email) { MembershipMailer.invitation_email(membership) }

    it "delivers to the user email" do
      email.should deliver_to(user.email)
    end

    describe "invitation note" do
      context "when note present" do
        before(:each) { membership.invitation_note = "This is an invitation note." }

        it "inserts who makes note" do
          email.should have_body_text("#{invited_by.first_name} also says:")
        end

        it "inserts invitation note" do
          email.should have_body_text("This is an invitation note.")
        end
      end

      context "when note does not present" do
        before(:each) { membership.invitation_note = "" }

        it "does not insert who could make note" do
          email.should_not have_body_text("#{invited_by.first_name} also says:")
        end
      end
    end

    describe "password" do
      context "when password present" do
        before(:each) { membership.user.password = "secret" }

        it "inserts password label" do
          email.should have_body_text("Password:")
        end

        it "inserts password" do
          email.should have_body_text("secret")
        end
      end

      context "when password does not present" do
        before(:each) { membership.user.password = nil }

        it "does not insert password label" do
          email.should_not have_body_text("Password:")
        end
      end
    end
  end
end
