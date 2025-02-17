Rails.application.routes.draw do
  get "home/index"
  resource :session
  resources :passwords, param: :token
  resources :registrations, only: %i[new create]

  scope :account do
    get "/" => "account#index", as: :account
    resource :profile
    resources :addresses do
      member do
        patch :make_default
      end
    end
    resource :subscription, only: %i[show]
    resource :settings, only: %i[show update edit]
  end

  resources :organizations do
    resources :memberships, except: %i[show new create]
    resources :invites, controller: "organization/invites" do
      member do
        post :resend
      end
    end
  end

  resolve("Profile") { [ :profile ] }

  flipper_app = Flipper::UI.app do |builder|
    builder.use Rack::Auth::Basic do |username, password|
      user = User.authenticate_by(email_address: username, password: password)

      user&.super_admin?
    end
  end
  mount flipper_app, at: "/flipper"

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  root "home#index"
end
