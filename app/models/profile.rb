class Profile < ApplicationRecord
  belongs_to :user
  has_one_attached :avatar

  validates :first_name, :last_name, presence: true
  validates :country, presence: true, if: -> { phone.present? }
  validates :country, length: { is: 2 }, if: -> { phone.present? }
end
