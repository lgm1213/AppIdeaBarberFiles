class ShopsController < ApplicationController
  before_action :require_user
  before_action :require_barber

  def index
    @shops = current_user.shops
  end

  def new
    @shop = Shop.new
  end

  def create
    @shop = current_user.shops.build(shop_params)
    if @shop.save
      redirect_to shops_path, notice: "Shop created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def require_barber
    redirect_to root_path, alert: "You are not authorized to perform this action." unless current_user.barber?
  end

  def shop_params
    params.require(:shop).permit(:name, :address)
  end
end
