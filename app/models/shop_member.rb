class ShopMember < ApplicationRecord
  belongs_to :shop
  belongs_to :user

  validates :user_id, uniqueness: { scope: :shop_id }

  scope :active, -> { where(active: true) }
end
