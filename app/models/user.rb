class User < ApplicationRecord
  has_secure_password
  has_one :profile, dependent: :destroy
  has_one :subscription, dependent: :destroy
  has_one :default_address, -> { where(default: true) }, class_name: "Address"
  has_one :setting, class_name: "User::Setting", dependent: :destroy

  has_many :sessions, dependent: :destroy
  has_many :addresses, dependent: :destroy
  has_many :purchases, dependent: :destroy

  has_many :memberships, dependent: :destroy
  has_many :organizations, through: :memberships
  has_many :sent_invites,
    class_name: "Organization::Invite",
    foreign_key: "inviter_id"
  has_many :received_invites,
    class_name: "Organization::Invite",
    foreign_key: "invited_user_id"

  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, presence: true

  default_scope { includes(:subscription, :setting) }

  enum :role, { regular: 0, admin: 1, super_admin: 2, banned: 3 }

  def has_active_subscription?
    subscription&.active?
  end

  def member_of?(organization)
    organizations.include?(organization)
  end

  def role_in(organization)
    memberships.find_by(organization: organization)&.role
  end

  def admin_of?(organization)
    %w[admin owner].include?(role_in(organization))
  end

  def owner_of?(organization)
    role_in(organization) == "owner"
  end
end
