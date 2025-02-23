require 'rails_helper'

RSpec.describe Organizations::CreateInvite do
  let(:call) { described_class.call(organization: organization, inviter: inviter, email: email, role: role) }
  let(:organization) { create(:organization) }
  let(:inviter) { create(:user) }
  let(:email) { "invited@test.com" }
  let(:role) { "member" }

  it "creates an invite" do
    expect { call }.to change(Organization::Invite, :count).by(1)
  end

  it "returns a successful result" do
    expect(call).to be_success
  end

  it "returns the invite" do
    expect(call.object).to be_a(Organization::Invite)
  end

  it "sets the organization" do
    expect(call.object.organization).to eq(organization)
  end

  it "sets the inviter" do
    expect(call.object.inviter).to eq(inviter)
  end

  it "sets the email" do
    expect(call.object.email).to eq(email)
  end

  it "sets the role" do
    expect(call.object.role).to eq(role)
  end

  context "when saving the invite fails" do
    before do
      allow_any_instance_of(Organization::Invite).to receive(:save).and_return(false)
    end

    it "returns a failed result" do
      expect(call).not_to be_success
    end

    it "does not create an invite" do
      expect { call }.not_to change(Organization::Invite, :count)
    end
  end

  context "when the invited email is an existing user" do
    let(:existing_user) { create(:user, email_address: email) }

    before do
      existing_user
    end

    it "sets the invited user" do
      expect(call.object.invited_user).to eq(existing_user)
    end
  end
end
