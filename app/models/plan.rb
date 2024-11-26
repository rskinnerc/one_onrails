class Plan < ApplicationRecord
  has_many :subscriptions

  scope :initial_subscription, -> { find_by(initial_subscription: true) }
end
