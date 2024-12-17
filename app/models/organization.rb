class Organization < ApplicationRecord
  has_many :memberships
  has_many :users, through: :memberships

  validates :name, presence: true, uniqueness: true

  scope :active, -> { where(archived_at: nil) }
end
