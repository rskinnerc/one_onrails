module Organizations
  class UpdateInvite
    include Callable

    def initialize(invite:, inviter:, email:, role:)
      @invite = invite
      @inviter = inviter
      @email = email
      @role = role
    end

    def call
      result(success: update_invite, object: invite)
    end

    private

    attr_reader :invite, :inviter, :email, :role

    def invited_user
      User.find_by(email_address: email)
    end

    def update_invite
      invite.update(inviter: inviter, email: email, role: role, invited_user: invited_user)
    end
  end
end
