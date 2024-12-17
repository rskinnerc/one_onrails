class CreateMemberships < ActiveRecord::Migration[8.0]
  def change
    create_table :memberships do |t|
      t.references :user, null: false, foreign_key: true
      t.references :organization, null: false, foreign_key: true
      t.integer :role, default: 0

      t.timestamps
    end

    add_index :memberships, [ :user_id, :organization_id ], unique: true
  end
end
