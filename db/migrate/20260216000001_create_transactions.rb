class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.references :shop, null: false, foreign_key: { on_delete: :cascade }
      t.references :barber, foreign_key: { to_table: :users, on_delete: :nullify }
      t.references :appointment, foreign_key: { on_delete: :nullify }
      t.string :transaction_type, null: false
      t.string :category, null: false
      t.integer :amount_cents, null: false
      t.text :description
      t.date :transaction_date, null: false

      t.timestamps
    end

    add_index :transactions, :transaction_type
    add_index :transactions, :transaction_date
  end
end
