class CreatePlans < ActiveRecord::Migration[8.0]
  def change
    create_table :plans do |t|
      t.string :name
      t.integer :price_cents
      t.string :currency
      t.integer :trial_duration_days
      t.text :description
      t.boolean :public

      t.timestamps
    end
  end
end
