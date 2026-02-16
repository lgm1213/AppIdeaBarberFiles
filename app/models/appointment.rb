class Appointment < ApplicationRecord
  belongs_to :client, class_name: "User"
  belongs_to :barber, class_name: "User"

  enum :status, { pending: "pending", confirmed: "confirmed", cancelled: "cancelled" }, default: :pending

  validates :barber_id, presence: true
  validates :client_id, presence: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validate :end_time_after_start_time

  private

  def end_time_after_start_time
    return if start_time.blank? || end_time.blank?

    if end_time <= start_time
      errors.add(:end_time, "must be after start time")
    end
  end
end
