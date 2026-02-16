Rails.application.config.middleware.use OmniAuth::Builder do
  if Rails.application.credentials.google.present?
    provider :google_oauth2,
             Rails.application.credentials.google[:client_id],
             Rails.application.credentials.google[:client_secret],
             scope: "email,profile"
  end

  if Rails.application.credentials.instagram.present?
    provider :instagram,
             Rails.application.credentials.instagram[:client_id],
             Rails.application.credentials.instagram[:client_secret]
  end
end

OmniAuth.config.allowed_request_methods = [ :post, :get ]
