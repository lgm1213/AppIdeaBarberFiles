class TransactionsController < ApplicationController
  before_action :require_user
  before_action :require_barber_or_staff
  before_action :set_shop
  before_action :set_transaction, only: [ :edit, :update, :destroy ]

  def new
    @transaction = @shop.transactions.build(transaction_type: params[:type] || "income", transaction_date: Date.current)
    @barbers = @shop.staff_barbers
  end

  def create
    @transaction = @shop.transactions.build(transaction_params)
    if @transaction.save
      redirect_to shop_path(@shop, tab: "revenue"), notice: "Transaction added successfully."
    else
      @barbers = @shop.staff_barbers
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @barbers = @shop.staff_barbers
  end

  def update
    if @transaction.update(transaction_params)
      redirect_to shop_path(@shop, tab: "revenue"), notice: "Transaction updated successfully."
    else
      @barbers = @shop.staff_barbers
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @transaction.destroy
    redirect_to shop_path(@shop, tab: "revenue"), notice: "Transaction deleted successfully."
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

  def set_transaction
    @transaction = @shop.transactions.find(params[:id])
  end

  def transaction_params
    params.require(:transaction).permit(:transaction_type, :category, :amount_cents, :description, :transaction_date, :barber_id)
  end
end
