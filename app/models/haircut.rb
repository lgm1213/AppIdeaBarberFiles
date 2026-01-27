class Haircut < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :barber, class_name: 'User'

  has_one_attached :image
end
