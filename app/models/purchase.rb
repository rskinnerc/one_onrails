class Purchase < ApplicationRecord
  belongs_to :subscription
  belongs_to :user
end
