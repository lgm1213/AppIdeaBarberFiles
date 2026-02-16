if Rails.application.credentials.stripe.present?
  Stripe.api_key = Rails.application.credentials.stripe[:api_key]
end
