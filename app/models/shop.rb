class Shop < ApplicationRecord
  belongs_to :barber, class_name: "User"
  has_many :chairs, dependent: :destroy
  has_many :transactions, dependent: :destroy
  has_many :inventory_items, dependent: :destroy
  has_many :shop_invitations, dependent: :destroy
  has_many :shop_members, dependent: :destroy
  has_many :staff_users, -> { where(shop_members: { role_in_shop: "staff", active: true }) }, through: :shop_members, source: :user
  has_many :staff_barbers, -> { distinct }, through: :chairs, source: :barber

  validates :name, presence: true
  validates :address, presence: true

  def total_revenue(start_date = nil, end_date = nil)
    scope = transactions.income
    scope = scope.for_date_range(start_date, end_date) if start_date && end_date
    scope.sum(:amount_cents) / 100.0
  end

  def total_expenses(start_date = nil, end_date = nil)
    scope = transactions.expenses
    scope = scope.for_date_range(start_date, end_date) if start_date && end_date
    scope.sum(:amount_cents) / 100.0
  end

  def net_revenue(start_date = nil, end_date = nil)
    total_revenue(start_date, end_date) - total_expenses(start_date, end_date)
  end

  def revenue_by_barber(start_date = nil, end_date = nil)
    scope = transactions.income.where.not(barber_id: nil)
    scope = scope.for_date_range(start_date, end_date) if start_date && end_date
    scope.group(:barber_id).sum(:amount_cents).transform_values { |v| v / 100.0 }
  end

  def low_stock_items
    inventory_items.low_stock
  end

  def out_of_stock_items
    inventory_items.out_of_stock
  end
end
