require 'rails_helper'

RSpec.describe MembershipPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:membership) { create(:membership, user: user, organization: organization, role: role) }
  let(:role) { 0 }
  let(:other_membership) { create(:membership, organization: organization) }
  let(:membership_from_other_organization) { create(:membership) }

  subject { described_class }

  before do
    membership
    other_membership
    membership_from_other_organization
  end

  permissions ".scope" do
    it "returns a scope" do
      expect(subject::Scope.new(user, organization).resolve).to include(membership, other_membership)
    end

    it "returns a scope" do
      expect(subject::Scope.new(user, organization).resolve).not_to include(membership_from_other_organization)
    end
  end

  permissions :show? do
    context "when user is a member of the organization" do
      it { is_expected.to permit(user, membership) }
    end

    context "when user is not a member of the organization" do
      it { is_expected.not_to permit(user, membership_from_other_organization) }
    end
  end

  permissions :create? do
    context "when user is not a member of the organization" do
      let(:role) { 2 }

      it { is_expected.not_to permit(user, membership_from_other_organization) }
    end

    context "when user is a member of the organization" do
      it { is_expected.not_to permit(user, membership) }
    end

    context "when user is an admin of the organization" do
      let(:role) { 1 }

      it { is_expected.not_to permit(user, membership) }
    end

    context "when user is an owner of the organization" do
      let(:role) { 2 }

      it { is_expected.to permit(user, membership) }
    end
  end

  permissions :update? do
    context "when user is not a member of the organization" do
      it { is_expected.not_to permit(user, membership_from_other_organization) }
    end

    context "when user is a member of the organization" do
      it { is_expected.not_to permit(user, membership) }
    end

    context "when user is an admin of the organization" do
      let(:role) { 1 }

      it { is_expected.not_to permit(user, membership) }
    end

    context "when user is an owner of the organization" do
      let(:role) { 2 }

      it { is_expected.to permit(user, other_membership) }

      context "when the user tries to update their own membership" do
        it { is_expected.not_to permit(user, membership) }
      end
    end
  end

  permissions :destroy? do
    context "when user is not a member of the organization" do
      it { is_expected.not_to permit(user, membership_from_other_organization) }
    end

    context "when user is a member of the organization" do
      it { is_expected.not_to permit(user, membership) }
    end

    context "when user is an admin of the organization" do
      let(:role) { 1 }

      it { is_expected.not_to permit(user, membership) }
    end

    context "when user is an owner of the organization" do
      let(:role) { 2 }

      it { is_expected.to permit(user, other_membership) }

      context "when the user tries to delete their own membership" do
        it { is_expected.not_to permit(user, membership) }
      end
    end
  end
end
