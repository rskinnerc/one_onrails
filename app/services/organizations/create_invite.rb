module Organizations
  class CreateInvite
    include Callable

    def initialize(organization:, inviter:, email:, role:)
      @organization = organization
      @inviter = inviter
      @email = email
      @role = role
    end

    def call
      params = {
        organization: organization,
        inviter: inviter,
        email: email,
        role: role,
        invited_user: invited_user
      }.compact

      invite = Organization::Invite.new(params)

      result(success: invite.save, object: invite)
    end

    private

    attr_reader :organization, :inviter, :email, :role

    def invited_user
      User.find_by(email_address: email)
    end
  end
end
