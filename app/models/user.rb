class User < ApplicationRecord
  self.inheritance_column = :role

  has_secure_password

  enum role: { client: 'Client', barber: 'Barber' }

  scope :clients, -> { where(role: 'Client') }
  scope :barbers, -> { where(role: 'Barber') }

  validates :email_address, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true
  validates :last_name, presence: true

  def self.from_omniauth(auth)
    where(provider: auth.provider, uid: auth.uid).first_or_create do |user|
      user.email_address = auth.info.email
      user.password = Devise.friendly_token[0, 20]
      user.first_name = auth.info.first_name
      user.last_name = auth.info.last_name
    end
  end
end
