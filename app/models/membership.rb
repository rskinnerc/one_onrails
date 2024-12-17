class Membership < ApplicationRecord
  belongs_to :user
  belongs_to :organization

  enum :role, {
    member: 0,
    admin: 1,
    owner: 2
  }

  # Validations
  validates :user_id, uniqueness: { scope: :organization_id }
  validate :single_owner_per_organization

  private

  def single_owner_per_organization
    if role_changed? && role == "owner"
      existing_owner = Membership.find_by(organization: organization, role: "owner")
      errors.add(:role, "An owner already exists for this organization") if existing_owner && existing_owner != self
    end
  end
end
