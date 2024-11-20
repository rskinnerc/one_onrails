class CreateAddresses < ActiveRecord::Migration[8.0]
  def change
    create_table :addresses do |t|
      t.string :address_line_1
      t.string :address_line_2
      t.string :city
      t.string :country
      t.string :state
      t.string :postal_code
      t.boolean :default
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
