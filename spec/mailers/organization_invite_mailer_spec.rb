require "rails_helper"

RSpec.describe OrganizationInviteMailer, type: :mailer do
  describe "invite" do
    let(:mail) { OrganizationInviteMailer.invite(organization_invite: organization_invite) }
    let(:organization_invite) { create(:organization_invite) }

    it "renders the headers" do
      expect(mail.subject).to eq("You have been invited to join an organization")
      expect(mail.to).to eq([ organization_invite.email ])
      expect(mail.from).to eq([ organization_invite.inviter.email_address ])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match(organization_invite.inviter.email_address)
      expect(mail.body.encoded).to match(organization_invite.organization.name)
    end
  end
end
