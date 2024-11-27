class CreateSubscriptions < ActiveRecord::Migration[8.0]
  def change
    create_table :subscriptions do |t|
      t.integer :status
      t.datetime :start_date
      t.datetime :end_date
      t.datetime :trial_end_date
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    add_index :subscriptions, :status
  end
end
