class Staff < User
  has_many :shop_members, foreign_key: "user_id"

  default_scope { where(role: "Staff") }
end
