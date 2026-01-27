class Chair < ApplicationRecord
  belongs_to :shop
  belongs_to :barber, class_name: 'User', optional: true

  validates :shop_id, presence: true
  validates :name, presence: true
end
