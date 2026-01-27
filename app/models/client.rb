class Client < User
  has_many :haircuts, foreign_key: 'client_id'
  has_many :appointments, foreign_key: 'client_id'
end
