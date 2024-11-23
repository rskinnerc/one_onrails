class CreateBillingHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :billing_histories do |t|
      t.references :subscription, null: false, foreign_key: true
      t.integer :amount_cents
      t.string :currency
      t.integer :event_type
      t.datetime :event_date
      t.text :metadata
      t.integer :tax_amount_cents
      t.integer :total_amount_cents
      t.decimal :tax_rate, precision: 4, scale: 2
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
