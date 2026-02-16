class CreateShopMembers < ActiveRecord::Migration[8.1]
  def change
    create_table :shop_members do |t|
      t.references :shop, null: false, foreign_key: { on_delete: :cascade }
      t.references :user, null: false, foreign_key: { on_delete: :cascade }
      t.string :role_in_shop, null: false, default: "staff"
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :shop_members, [ :shop_id, :user_id ], unique: true
  end
end
