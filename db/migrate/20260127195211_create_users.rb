class CreateUsers < ActiveRecord::Migration[8.1]
  def change
    enable_extension 'pgcrypto'

    create_table :users, id: :uuid do |t|
      t.string :first_name
      t.string :last_name
      t.string :email_address
      t.string :password_digest
      t.string :role

      t.timestamps
    end
  end
end
