class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  before_action :check_registrations_enabled

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      start_new_session_for @user
      redirect_to after_authentication_url, notice: "Welcome! Your account has been created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation)
  end

  def check_registrations_enabled
    unless Rails.application.credentials.allow_registrations
      redirect_to root_path, alert: "Registrations are currently disabled."
    end
  end
end