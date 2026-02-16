class CreateHaircuts < ActiveRecord::Migration[8.1]
  def change
    create_table :haircuts, id: :uuid do |t|
      t.uuid :client_id
      t.uuid :barber_id
      t.text :details

      t.timestamps
    end
  end
end
