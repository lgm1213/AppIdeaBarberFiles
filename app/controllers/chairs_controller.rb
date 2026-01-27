class ChairsController < ApplicationController
  before_action :require_user
  before_action :require_barber
  before_action :set_shop

  def index
    @chairs = @shop.chairs
  end

  def new
    @chair = @shop.chairs.build
  end

  def create
    @chair = @shop.chairs.build(chair_params)
    if @chair.save
      redirect_to shop_chairs_path(@shop), notice: "Chair created successfully."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def require_barber
    redirect_to root_path, alert: "You are not authorized to perform this action." unless current_user.barber?
  end

  def set_shop
    @shop = current_user.shops.find(params[:shop_id])
  end

  def chair_params
    params.require(:chair).permit(:name, :is_available, :barber_id)
  end
end
