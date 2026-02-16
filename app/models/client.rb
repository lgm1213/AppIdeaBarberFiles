class Client < User
  has_many :haircuts, foreign_key: "client_id", dependent: :destroy
  has_many :appointments, foreign_key: "client_id", dependent: :destroy

  default_scope { where(role: "Client") }
end
