class Profile < ApplicationRecord
  belongs_to :user
  belongs_to :profile
  has_one_attached :avatar
end
