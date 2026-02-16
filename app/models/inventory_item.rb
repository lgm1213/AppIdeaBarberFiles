class InventoryItem < ApplicationRecord
  belongs_to :shop

  validates :name, presence: true
  validates :quantity, numericality: { greater_than_or_equal_to: 0 }

  scope :low_stock, -> { where("quantity <= low_stock_threshold AND quantity > 0") }
  scope :out_of_stock, -> { where(quantity: 0) }

  def low_stock?
    quantity <= low_stock_threshold && quantity > 0
  end

  def out_of_stock?
    quantity == 0
  end

  def stock_status
    if out_of_stock?
      "out_of_stock"
    elsif low_stock?
      "low_stock"
    else
      "in_stock"
    end
  end

  def reorder_cost_dollars
    return nil unless reorder_cost_cents
    reorder_cost_cents / 100.0
  end
end
