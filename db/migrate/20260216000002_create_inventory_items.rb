class CreateInventoryItems < ActiveRecord::Migration[8.1]
  def change
    create_table :inventory_items do |t|
      t.references :shop, null: false, foreign_key: { on_delete: :cascade }
      t.string :name, null: false
      t.text :description
      t.integer :quantity, default: 0
      t.integer :low_stock_threshold, default: 10
      t.string :unit
      t.string :vendor_name
      t.string :vendor_contact
      t.integer :reorder_cost_cents
      t.string :sku

      t.timestamps
    end
  end
end
