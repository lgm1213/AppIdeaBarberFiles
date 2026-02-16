class AddRoleTypeToShopInvitations < ActiveRecord::Migration[8.1]
  def change
    add_column :shop_invitations, :role_type, :string, default: "barber"
  end
end
