class Purchase < ApplicationRecord
  belongs_to :subscription, optional: true
  belongs_to :user

  validates :amount_cents, presence: true
  validates :tax_amount_cents, :total_amount_cents, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :currency, presence: true
  validates :tax_rate, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }

  enum :status, { pending: 0, completed: 1, failed: 2, canceled: 3 }
end
