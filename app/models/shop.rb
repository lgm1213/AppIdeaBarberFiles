class Shop < ApplicationRecord
  belongs_to :barber, class_name: 'User'
  has_many :chairs

  validates :name, presence: true
  validates :address, presence: true
  validates :barber_id, presence: true
end
