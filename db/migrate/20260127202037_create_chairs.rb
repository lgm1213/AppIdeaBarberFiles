class CreateChairs < ActiveRecord::Migration[8.1]
  def change
    create_table :chairs, id: :uuid do |t|
      t.uuid :shop_id
      t.uuid :barber_id
      t.string :name
      t.boolean :is_available

      t.timestamps
    end
  end
end
