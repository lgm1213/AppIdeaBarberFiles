class AddStripeChargeIdToAppointments < ActiveRecord::Migration[8.1]
  def change
    add_column :appointments, :stripe_charge_id, :string
  end
end
