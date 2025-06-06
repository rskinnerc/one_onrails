class Address < ApplicationRecord
  belongs_to :user

  validates :address_line_1, :city, :country, presence: true
  validates :default, uniqueness: { scope: :user_id }, if: :default?

  def to_s
    "#{address_line_1}, #{city}, #{country}"
  end
end
