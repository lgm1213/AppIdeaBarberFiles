class Transaction < ApplicationRecord
  belongs_to :shop
  belongs_to :barber, class_name: "User", optional: true
  belongs_to :appointment, optional: true

  validates :transaction_type, presence: true, inclusion: { in: %w[income expense] }
  validates :category, presence: true
  validates :amount_cents, presence: true, numericality: { greater_than: 0 }
  validates :transaction_date, presence: true

  scope :income, -> { where(transaction_type: "income") }
  scope :expenses, -> { where(transaction_type: "expense") }
  scope :for_date_range, ->(start_date, end_date) { where(transaction_date: start_date..end_date) }

  def amount_dollars
    amount_cents / 100.0
  end
end
