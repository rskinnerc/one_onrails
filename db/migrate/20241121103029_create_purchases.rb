class CreatePurchases < ActiveRecord::Migration[8.0]
  def change
    create_table :purchases do |t|
      t.references :subscription, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :amount_cents, default: 0
      t.integer :tax_amount_cents
      t.decimal :tax_rate, precision: 4, scale: 2, default: 0.0
      t.integer :total_amount_cents
      t.string :currency
      t.string :description
      t.integer :status, default: 0

      t.timestamps
    end
  end
end
