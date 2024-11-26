class RegistrationsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]

  def new
    if authenticated?
      redirect_to root_path, alert: "You are already logged in."
    end
  end

  def create
    user = User.new(user_params)
    if user.save!
      Users::CreateInitialSubscription.call(user: user)
      start_new_session_for user
      redirect_to after_authentication_url
    else
      render :new, status: :unprocessable_entity
    end
  end

  private
    def user_params
      params.permit(:email_address, :password, :password_confirmation)
    end
end
