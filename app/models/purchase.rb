class Purchase < ApplicationRecord
  belongs_to :subscription, optional: true
  belongs_to :user
end
