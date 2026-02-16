class Barber < User
  has_many :haircuts, foreign_key: "barber_id", dependent: :destroy
  has_many :appointments, foreign_key: "barber_id", dependent: :destroy
  has_many :shops, foreign_key: "barber_id", dependent: :destroy
  has_many :rented_chairs, class_name: "Chair", foreign_key: "barber_id", dependent: :nullify

  default_scope { where(role: "Barber") }
end
