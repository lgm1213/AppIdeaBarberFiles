class Appointment < ApplicationRecord
  belongs_to :client, class_name: 'User'
  belongs_to :barber, class_name: 'User'

  enum status: { pending: 'pending', confirmed: 'confirmed', cancelled: 'cancelled' }

  validates :barber_id, presence: true
  validates :client_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
end
