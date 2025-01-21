class CreateOrganizationInvites < ActiveRecord::Migration[8.0]
  def change
    create_table :organization_invites do |t|
      t.references :organization, null: false, foreign_key: true
      t.references :inviter, null: false, foreign_key: { to_table: :users }
      t.references :invited_user, foreign_key: { to_table: :users }
      t.string :email, null: false
      t.integer :status, default: 0, null: false
      t.integer :role, default: 0, null: false
      t.string :token, null: false

      t.timestamps
    end

    add_index :organization_invites, :token, unique: true
    add_index :organization_invites, [ :organization_id, :email ], unique: true
  end
end
