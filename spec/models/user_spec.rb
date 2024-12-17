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

    describe "#has_active_subscription?" do
      let(:plan) { create(:plan) }

      context "when the user has an active subscription" do
        let(:status) { :active }

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
  end
end
