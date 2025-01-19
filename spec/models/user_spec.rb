require 'rails_helper'

RSpec.describe User, type: :model do
  describe "associations" do
    it { should have_many(:sessions).dependent(:destroy) }
    it { should have_one(:profile).dependent(:destroy) }
    it { should have_secure_password }
    it { should have_many(:addresses).dependent(:destroy) }
    it { should have_one(:default_address).conditions(default: true).class_name("Address") }
    it { should have_one(:subscription).dependent(:destroy) }
    it { should have_many(:purchases).dependent(:destroy) }
    it { should have_one(:setting).dependent(:destroy) }
    it { should have_many(:memberships).dependent(:destroy) }
    it { should have_many(:organizations).through(:memberships) }
    it { should have_many(:sent_invites).class_name("Organization::Invite").with_foreign_key("inviter_id") }
    it { should have_many(:received_invites).class_name("Organization::Invite").with_foreign_key("invited_user_id") }
  end

  describe "validations" do
    it { is_expected.to normalize(:email_address).from("Test@TEST.com").to("test@test.com") }
    it { is_expected.to validate_presence_of(:email_address) }
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values(%i[regular admin super_admin banned]) }
  end

  describe "scopes" do
    describe "default_scope" do
      it "includes the subscription" do
        expect(User.all.includes_values).to include(:subscription)
      end

      it "includes the setting" do
        expect(User.all.includes_values).to include(:setting)
      end
    end
  end

  describe "methods" do
    let(:subject) { create(:user) }
    let!(:subscription) { create(:subscription, user: subject, plan: plan, status: status) }
    let(:plan) { create(:plan) }
    let(:status) { :active }

    describe "#has_active_subscription?" do
      context "when the user has an active subscription" do
        it "returns true" do
          expect(subject.has_active_subscription?).to be true
        end
      end

      context "when the user has a trialing subscription" do
        let(:status) { :trialing }

        it "returns false" do
          expect(subject.has_active_subscription?).to be false
        end
      end

      context "when the user has a paused subscription" do
        let(:status) { :paused }

        it "returns false" do
          expect(subject.has_active_subscription?).to be false
        end
      end

      context "when the user has a canceled subscription" do
        let(:status) { :canceled }

        it "returns false" do
          expect(subject.has_active_subscription?).to be false
        end
      end
    end

    describe "#member_of?" do
      let(:organization) { create(:organization) }

      context "when the user is a member of the organization" do
        before { subject.organizations << organization }

        it "returns true" do
          expect(subject.member_of?(organization)).to be true
        end
      end

      context "when the user is not a member of the organization" do
        it "returns false" do
          expect(subject.member_of?(organization)).to be false
        end
      end
    end

    describe "#role_in" do
      let(:organization) { create(:organization) }
      let!(:membership) { create(:membership, user: subject, organization: organization, role: role) }

      context "when the user has a role in the organization" do
        let(:role) { "admin" }

        it "returns the role" do
          expect(subject.role_in(organization)).to eq(role)
        end
      end
    end

    describe "#admin_of?" do
      let(:organization) { create(:organization) }

      context "when the user is an admin of the organization" do
        before { create(:membership, user: subject, organization: organization, role: "admin") }

        it "returns true" do
          expect(subject.admin_of?(organization)).to be true
        end
      end

      context "when the user is an owner of the organization" do
        before { create(:membership, user: subject, organization: organization, role: "owner") }

        it "returns true" do
          expect(subject.admin_of?(organization)).to be true
        end
      end

      context "when the user is not an admin of the organization" do
        it "returns false" do
          expect(subject.admin_of?(organization)).to be false
        end
      end
    end

    describe "#owner_of?" do
      let(:organization) { create(:organization) }

      context "when the user is an owner of the organization" do
        before { create(:membership, user: subject, organization: organization, role: "owner") }

        it "returns true" do
          expect(subject.owner_of?(organization)).to be true
        end
      end

      context "when the user is not an owner of the organization" do
        it "returns false" do
          expect(subject.owner_of?(organization)).to be false
        end
      end
    end
  end
end
