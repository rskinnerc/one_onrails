require 'rails_helper'

RSpec.describe OrganizationPolicy, type: :policy do
  let(:user) { create(:user) }
  let(:organization) { create(:organization) }
  let(:non_member_organization) { create(:organization) }
  let(:membership) { create(:membership, user: user, organization: organization, role: role) }
  let(:role) { "member" }

  subject { described_class }

  before do
    membership
  end

  permissions ".scope" do
    it "returns a scope" do
      expect(subject::Scope.new(user, Organization).resolve).to include(organization)
    end

    it "returns a scope" do
      expect(subject::Scope.new(user, Organization).resolve).not_to include(non_member_organization)
    end
  end

  permissions :show? do
    context "when user is a member of the organization" do
      it { is_expected.to permit(user, organization) }
    end

    context "when user is not a member of the organization" do
      it { is_expected.not_to permit(user, non_member_organization) }
    end
  end

  permissions :create? do
    context "when user has an active subscription" do
      let(:subscription) { create(:subscription, user: user, plan: plan) }

      context "when user has not reached the organization limit" do
        let(:plan) { create(:plan, organizations_limit: 10) }

        before do
          subscription
        end

        it { is_expected.to permit(user, organization) }
      end

      context "when user has reached the organization limit" do
        let(:plan) { create(:plan, organizations_limit: 0) }

        before do
          plan
        end

        it { is_expected.not_to permit(user, organization) }
      end
    end

    context "when user does not have an active subscription" do
      it { is_expected.not_to permit(user, organization) }
    end
  end

  permissions :update? do
    context "when user is a member of the organization" do
      it { is_expected.not_to permit(user, organization) }
    end

    context "when user is admin of the organization" do
      let(:role) { "admin" }

      it { is_expected.not_to permit(user, organization) }
    end

    context "when user is owner of the organization" do
      let(:role) { "owner" }

      it { is_expected.to permit(user, organization) }
    end
  end

  permissions :destroy? do
    context "when user is a member of the organization" do
      it { is_expected.not_to permit(user, organization) }
    end

    context "when user is admin of the organization" do
      let(:role) { "admin" }

      it { is_expected.not_to permit(user, organization) }
    end

    context "when user is owner of the organization" do
      let(:role) { "owner" }

      it { is_expected.to permit(user, organization) }
    end
  end

  permissions :list_memberships? do
    context "when user is a member of the organization" do
      it { is_expected.to permit(user, organization) }
    end

    context "when user is not a member of the organization" do
      it { is_expected.not_to permit(user, non_member_organization) }
    end
  end

  permissions :add_membership? do
    context "when user is a member of the organization" do
      it { is_expected.not_to permit(user, organization) }
    end

    context "when user is admin of the organization" do
      let(:role) { "admin" }

      it { is_expected.not_to permit(user, organization) }
    end

    context "when the user is owner of the organization" do
      let(:role) { "owner" }

      it { is_expected.to permit(user, organization) }
    end

    context "when user is not a member of the organization" do
      it { is_expected.not_to permit(user, non_member_organization) }
    end
  end
end
