require 'rails_helper'

RSpec.describe Organization::Invite, type: :model do
  describe "associations" do
    it { should belong_to(:organization) }
    it { should belong_to(:inviter).class_name("User") }
    it { should belong_to(:invited_user).class_name("User").optional }
  end

  describe "has_secure_token" do
    it { should have_secure_token(:token) }
  end

  describe "validations" do
    it { should validate_presence_of(:email) }
    it { should allow_value("some@email.com").for(:email) }
    it { should_not allow_value("someemail.com").for(:email) }
    it { should_not allow_value("some@.com").for(:email) }
    it { should_not allow_value("some.com").for(:email) }
    it { should_not allow_value('owner').for(:role) }

    context "unique_pending_invite" do
      let(:organization) { create(:organization) }
      let(:invite) { create(:organization_invite, organization: organization, email: "some@email.com") }

      it "adds an error if an invite already exists for the organization" do
        invite2 = build(:organization_invite, organization: organization, email: invite.email)
        invite2.valid?
        expect(invite2.errors[:email]).to include("already has a pending invite")
      end
    end
  end

  describe "enums" do
    it { should define_enum_for(:status).with_values(pending: 0, accepted: 1, declined: 2) }
    it { should define_enum_for(:role).with_values(member: 0, admin: 1, owner: 2) }
  end
end
