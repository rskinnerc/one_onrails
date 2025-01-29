class OrganizationInviteMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.organization_invite_mailer.invite.subject
  #
  def invite(organization_invite:)
    @organization_invite = organization_invite
    @organization = organization_invite.organization
    @inviter = organization_invite.inviter

    mail subject: "You have been invited to join an organization",
    to: organization_invite.email,
    from: organization_invite.inviter.email_address
  end
end
