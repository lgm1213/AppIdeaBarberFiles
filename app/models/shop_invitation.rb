class ShopInvitation < ApplicationRecord
  belongs_to :shop
  belongs_to :invited_by, class_name: "User"
  belongs_to :barber, class_name: "User", optional: true

  validates :email_address, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :token, presence: true, uniqueness: true
  validates :status, inclusion: { in: %w[pending accepted declined expired] }
  validates :role_type, inclusion: { in: %w[barber staff] }
  validates :expires_at, presence: true

  before_validation :generate_token_and_expiration, on: :create

  def accept!(user)
    update!(status: "accepted", barber: user)

    if role_type == "staff"
      ShopMember.find_or_create_by!(shop: shop, user: user) do |member|
        member.role_in_shop = "staff"
        member.active = true
      end
    end
  end

  def decline!
    update!(status: "declined")
  end

  def expired?
    expires_at < Time.current
  end

  private

  def generate_token_and_expiration
    self.token ||= SecureRandom.urlsafe_base64(32)
    self.expires_at ||= 7.days.from_now
  end
end
