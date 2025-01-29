class Organization::Invite < ApplicationRecord
  has_secure_token :token

  belongs_to :organization
  belongs_to :inviter, class_name: "User"
  belongs_to :invited_user, class_name: "User", optional: true

  enum :status, {
    pending: 0,
    accepted: 1,
    declined: 2
  }

  enum :role, {
    member: 0,
    admin: 1,
    owner: 2
  }

  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :role, inclusion: { in: self.roles.keys.reject { |key| key == "owner" } }
  validate :unique_pending_invite

  private

  def unique_pending_invite
    existing = Organization::Invite
      .where(organization: organization, email: email, status: :pending)
      .where.not(id: id)

    errors.add(:email, "already has a pending invite") if existing.exists?
  end
end
