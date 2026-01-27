class AddAmountToAppointments < ActiveRecord::Migration[8.1]
  def change
    add_column :appointments, :amount, :integer
  end
end
