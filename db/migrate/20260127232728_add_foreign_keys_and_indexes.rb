class AddForeignKeysAndIndexes < ActiveRecord::Migration[8.1]
  def change
    # Add indexes for foreign keys (improves query performance)
    add_index :appointments, :barber_id, if_not_exists: true
    add_index :appointments, :client_id, if_not_exists: true
    add_index :appointments, :status, if_not_exists: true

    add_index :chairs, :shop_id, if_not_exists: true
    add_index :chairs, :barber_id, if_not_exists: true

    add_index :haircuts, :barber_id, if_not_exists: true
    add_index :haircuts, :client_id, if_not_exists: true

    add_index :shops, :barber_id, if_not_exists: true

    add_index :users, :email_address, unique: true, if_not_exists: true
    add_index :users, :role, if_not_exists: true
    add_index :users, [ :provider, :uid ], if_not_exists: true

    # Add foreign key constraints (ensures data integrity)
    add_foreign_key :appointments, :users, column: :barber_id, on_delete: :cascade
    add_foreign_key :appointments, :users, column: :client_id, on_delete: :cascade

    add_foreign_key :chairs, :shops, on_delete: :cascade
    add_foreign_key :chairs, :users, column: :barber_id, on_delete: :nullify

    add_foreign_key :haircuts, :users, column: :barber_id, on_delete: :cascade
    add_foreign_key :haircuts, :users, column: :client_id, on_delete: :cascade

    add_foreign_key :shops, :users, column: :barber_id, on_delete: :cascade
  end
end
