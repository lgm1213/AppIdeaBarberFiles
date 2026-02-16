class Chair < ApplicationRecord
  belongs_to :shop
  belongs_to :barber, class_name: "User", optional: true

  validates :name, presence: true

  attribute :is_available, :boolean, default: true
end
