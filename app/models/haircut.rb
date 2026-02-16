class Haircut < ApplicationRecord
  belongs_to :client, class_name: "User"
  belongs_to :barber, class_name: "User"

  has_many_attached :images

  validates :client_id, presence: true
  validates :barber_id, presence: true
end
