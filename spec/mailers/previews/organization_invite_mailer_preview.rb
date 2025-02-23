# Preview all emails at http://localhost:3000/rails/mailers/organization_invite_mailer
class OrganizationInviteMailerPreview < ActionMailer::Preview
  # Preview this email at http://localhost:3000/rails/mailers/organization_invite_mailer/invite
  def invite
    OrganizationInviteMailer.invite(organization_invite: FactoryBot.create(:organization_invite))
  end
end
