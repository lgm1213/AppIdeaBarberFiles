class CreateHaircuts < ActiveRecord::Migration[8.1]
  def change
    create_table :haircuts do |t|
      t.integer :client_id
      t.integer :barber_id
      t.text :details

      t.timestamps
    end
  end
end
