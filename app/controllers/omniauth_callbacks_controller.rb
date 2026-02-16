class OmniauthCallbacksController < ApplicationController
  def google_oauth2
    handle_oauth_callback
  end

  def instagram
    handle_oauth_callback
  end

  def failure
    redirect_to login_path, alert: "Authentication failed. Please try again."
  end

  private

  def handle_oauth_callback
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      session[:user_id] = @user.id
      redirect_to root_path, notice: "Successfully signed in with #{params[:action].titleize}."
    else
      redirect_to login_path, alert: "Could not authenticate. #{@user.errors.full_messages.join(', ')}"
    end
  end
end
