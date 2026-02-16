class ShopsController < ApplicationController
  before_action :require_user
  before_action :require_barber_or_staff
  before_action :require_shop_owner, only: [ :new, :create ]

  def index
    if current_user.barber?
      @shops = current_user.shops
    elsif current_user.staff?
      shop = current_user.staff_shop
      @shops = shop ? Shop.where(id: shop.id) : Shop.none
    end
  end

  def show
    @shop = find_shop_for_user(params[:id])
    @active_tab = params[:tab].presence || "staff"

    case @active_tab
    when "staff"
      @chairs = @shop.chairs.includes(:barber)
      @staff_barbers = @shop.staff_barbers
      @staff_members = @shop.staff_users
      @pending_invitations = @shop.shop_invitations.where(status: "pending")
    when "revenue"
      @date_range = params[:range].presence || "all_time"
      start_date, end_date = date_range_for(@date_range)
      @transactions = @shop.transactions.includes(:barber).order(transaction_date: :desc)
      @transactions = @transactions.for_date_range(start_date, end_date) if start_date && end_date
      @total_revenue = @shop.total_revenue(start_date, end_date)
      @total_expenses = @shop.total_expenses(start_date, end_date)
      @net_revenue = @shop.net_revenue(start_date, end_date)
      @revenue_by_barber = @shop.revenue_by_barber(start_date, end_date)
      @barbers_map = User.where(id: @revenue_by_barber.keys).index_by(&:id)
    when "inventory"
      @inventory_items = @shop.inventory_items.order(:name)
      @low_stock_count = @shop.low_stock_items.count
      @out_of_stock_count = @shop.out_of_stock_items.count
    end
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

  def require_barber_or_staff
    unless current_user.barber? || current_user.staff?
      redirect_to root_path, alert: "You are not authorized to perform this action."
    end
  end

  def shop_params
    params.require(:shop).permit(:name, :address)
  end

  def date_range_for(range)
    case range
    when "today"
      [ Date.current, Date.current ]
    when "this_week"
      [ Date.current.beginning_of_week, Date.current.end_of_week ]
    when "this_month"
      [ Date.current.beginning_of_month, Date.current.end_of_month ]
    when "this_year"
      [ Date.current.beginning_of_year, Date.current.end_of_year ]
    else
      [ nil, nil ]
    end
  end
end
