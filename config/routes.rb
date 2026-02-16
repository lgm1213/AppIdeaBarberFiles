Rails.application.routes.draw do
  resources :marketing_campaigns, only: [ :new, :create ]

  # OmniAuth routes
  get "/auth/google_oauth2/callback", to: "omniauth_callbacks#google_oauth2"
  get "/auth/instagram/callback", to: "omniauth_callbacks#instagram"
  get "/auth/failure", to: "omniauth_callbacks#failure"

  resources :shops do
    resources :chairs, only: [ :index, :new, :create ]
  end

  resources :appointments do
    resources :payments, only: [ :new, :create ]
  end

  resources :haircuts

  # Authentication routes
  get "signup", to: "users#new"
  post "signup", to: "users#create"

  get "login", to: "sessions#new"
  post "login", to: "sessions#create"
  delete "logout", to: "sessions#destroy"

  # Root path - landing page for guests, redirects to appointments for logged in users
  root "pages#home"
end
