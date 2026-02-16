class Shop < ApplicationRecord
  belongs_to :barber, class_name: "User"
  has_many :chairs, dependent: :destroy

  validates :name, presence: true
  validates :address, presence: true
end
