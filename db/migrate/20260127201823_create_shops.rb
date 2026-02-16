class CreateShops < ActiveRecord::Migration[8.1]
  def change
    create_table :shops, id: :uuid do |t|
      t.string :name
      t.string :address
      t.uuid :barber_id

      t.timestamps
    end
  end
end
