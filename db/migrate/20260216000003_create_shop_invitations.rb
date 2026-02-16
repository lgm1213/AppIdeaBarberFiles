class CreateShopInvitations < ActiveRecord::Migration[8.1]
  def change
    create_table :shop_invitations do |t|
      t.references :shop, null: false, foreign_key: { on_delete: :cascade }
      t.references :invited_by, null: false, foreign_key: { to_table: :users, on_delete: :cascade }
      t.references :barber, foreign_key: { to_table: :users, on_delete: :nullify }
      t.string :email_address, null: false
      t.string :token, null: false
      t.string :status, default: "pending"
      t.datetime :expires_at, null: false
      t.text :message

      t.timestamps
    end

    add_index :shop_invitations, :token, unique: true
  end
end
