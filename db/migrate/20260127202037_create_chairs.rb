class CreateChairs < ActiveRecord::Migration[8.1]
  def change
    create_table :chairs do |t|
      t.integer :shop_id
      t.integer :barber_id
      t.string :name
      t.boolean :is_available

      t.timestamps
    end
  end
end
