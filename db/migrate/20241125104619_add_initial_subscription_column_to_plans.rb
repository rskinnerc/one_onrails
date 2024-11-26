class AddInitialSubscriptionColumnToPlans < ActiveRecord::Migration[8.0]
  def change
    add_column :plans, :initial_subscription, :boolean, default: false
    add_index :plans, :initial_subscription, unique: true
  end
end
