require "rails_helper"

RSpec.describe Organizations::UpdateInvite do
  let(:call) { described_class.call(invite: invite, inviter: inviter, email: email, role: role) }
  let(:invite) { create(:organization_invite) }
  let(:inviter) { create(:user) }
  let(:email) { "updated_email@test-email.com" }
  let(:role) { "member" }

  it "updates the invited email" do
    call
    expect(invite.reload.email).to eq(email)
  end

  it "updates the role" do
    call
    expect(invite.reload.role).to eq(role)
  end

  it "updates the inviter" do
    call
    expect(invite.reload.inviter).to eq(inviter)
  end

  it "updates the invited user" do
    call
    expect(invite.reload.invited_user).to be_nil
  end

  it "returns a successful result" do
    expect(call).to be_success
  end

  it "returns the invite" do
    expect(call.object).to eq(invite)
  end

  context "when saving the invite fails" do
    before do
      allow_any_instance_of(Organization::Invite).to receive(:update).and_return(false)
    end

    it "returns a failed result" do
      expect(call).not_to be_success
    end

    it "does not update the invite" do
      call
      expect(invite.reload.email).not_to eq(email)
    end
  end

  context "when the invited email is an existing user" do
    let(:existing_user) { create(:user, email_address: email) }

    before do
      existing_user
    end

    it "updates the invited user" do
      call
      expect(invite.reload.invited_user).to eq(existing_user)
    end
  end
end
