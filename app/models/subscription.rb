class Subscription < ApplicationRecord
  belongs_to :user
  has_many :purchases
  belongs_to :plan

  enum :status, { trialing: 0, active: 1, paused: 2, canceled: 3, expired: 4 }
end
