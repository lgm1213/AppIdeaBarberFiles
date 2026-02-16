class User < ApplicationRecord
  self.inheritance_column = :role

  has_secure_password

  # Associations (also defined in subclasses for STI)
  has_many :barber_appointments, class_name: "Appointment", foreign_key: "barber_id"
  has_many :client_appointments, class_name: "Appointment", foreign_key: "client_id"
  has_many :shops, foreign_key: "barber_id"
  has_many :haircuts_as_barber, class_name: "Haircut", foreign_key: "barber_id"
  has_many :haircuts_as_client, class_name: "Haircut", foreign_key: "client_id"

  scope :clients, -> { where(role: "Client") }
  scope :barbers, -> { where(role: "Barber") }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email_address = auth.info.email
      user.password = SecureRandom.hex(10)
      user.first_name = auth.info.first_name || auth.info.name&.split&.first || "User"
      user.last_name = auth.info.last_name || auth.info.name&.split&.last || "User"
      user.role = "Client" # Default role for OAuth users
    end
  end

  def barber?
    role == "Barber"
  end

  def client?
    role == "Client"
  end

  # Unified method to get appointments based on role
  def appointments
    if barber?
      barber_appointments
    else
      client_appointments
    end
  end

  # Unified method to get haircuts based on role
  def haircuts
    if barber?
      haircuts_as_barber
    else
      haircuts_as_client
    end
  end
end
