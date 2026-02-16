class InventoryItemsController < ApplicationController
  before_action :require_user
  before_action :require_barber_or_staff
  before_action :set_shop
  before_action :set_inventory_item, only: [ :edit, :update, :destroy ]

  def new
    @inventory_item = @shop.inventory_items.build
  end

  def create
    @inventory_item = @shop.inventory_items.build(inventory_item_params)
    if @inventory_item.save
      redirect_to shop_path(@shop, tab: "inventory"), notice: "Item added successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @inventory_item.update(inventory_item_params)
      redirect_to shop_path(@shop, tab: "inventory"), notice: "Item updated successfully."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @inventory_item.destroy
    redirect_to shop_path(@shop, tab: "inventory"), notice: "Item deleted successfully."
  end

  private

  def require_barber_or_staff
    unless current_user.barber? || current_user.staff?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end

  def set_shop
    @shop = find_shop_for_user(params[:shop_id])
  end

  def set_inventory_item
    @inventory_item = @shop.inventory_items.find(params[:id])
  end

  def inventory_item_params
    params.require(:inventory_item).permit(:name, :description, :quantity, :low_stock_threshold, :unit, :vendor_name, :vendor_contact, :reorder_cost_cents, :sku)
  end
end
