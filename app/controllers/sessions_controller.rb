class SessionsController < ApplicationController
  allow_unauthenticated_access only: %i[ new create ]
  rate_limit to: 10, within: 3.minutes, only: :create, with: -> { redirect_to new_session_url, alert: "Try again later." }

  def new
  end

  def create
    if user = User.authenticate_by(email_address: session_params[:email_address], password: session_params[:password])
      start_new_session_for user
      redirect_to after_authentication_url
    else
      redirect_to new_session_url, alert: "Invalid email address or password."
    end
  end

  def destroy
    terminate_session
    redirect_to new_session_url
  end

  private

  def session_params
    params.permit(:email_address, :password, :authenticity_token, :commit)
  end
end
