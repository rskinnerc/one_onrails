class Subscription < ApplicationRecord
  belongs_to :user
  belongs_to :plan
  has_many :purchases
  has_many :billing_histories

  enum :status, { trialing: 0, active: 1, paused: 2, canceled: 3, expired: 4 }
end
