class AddPricingDetailColumnsToPlans < ActiveRecord::Migration[8.0]
  def change
    add_column :plans, :annual_discount_percentage, :decimal, precision: 5, scale: 2
  end
end
