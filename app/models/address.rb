class Address < ApplicationRecord
  belongs_to :user

  validates :default, uniqueness: { scope: :user_id }, if: :default?
end
