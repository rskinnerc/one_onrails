require 'rails_helper'

RSpec.describe Membership, type: :model do
  describe "associations" do
    it { should belong_to(:user) }
    it { should belong_to(:organization) }
  end

  describe "enums" do
    it { should define_enum_for(:role).with_values({ member: 0, admin: 1, owner: 2 }) }
  end

  describe "validations" do
    let(:user) { create(:user) }
    let(:organization) { create(:organization) }
    let!(:existing_membership) { create(:membership, user: user, organization: organization) }

    it { should validate_presence_of(:role) }
    it { should validate_uniqueness_of(:user_id).scoped_to(:organization_id).with_message('has already been taken') }

    describe "single_owner_per_organization" do
      let!(:existing_owner) { create(:membership, organization: organization, role: "owner") }
      let(:membership) { build(:membership, organization: organization, role: "owner") }

      context "when the role is changed to owner" do
        it "adds an error if an owner already exists for the organization" do
          membership.save
          expect(membership.errors[:role]).to include("An owner already exists for this organization")
        end
      end

      context "when the role is not changed to owner" do
        it "does not add an error" do
          membership.role = "admin"
          membership.save
          expect(membership.errors[:role]).to be_empty
        end
      end
    end
  end
end
