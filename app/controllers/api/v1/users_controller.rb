class Api::V1::UsersController < ApplicationController
  include ActionView::Helpers::NumberHelper
  before_action :authenticate_request, only: [:me]

  def index
    users = User.all
    render json: users, status: :ok
  end

  def me
    if @current_user
      render json: { user: @current_user }, status: :ok
    else
      render json: { error: "Invalid token" }, status: :unauthorized
    end
  end

  def show_profile
    user = User.second
    render json: user, status: :ok
  end

  def update_profile
    user = Current.user
    if user.update(profile_params)
      render json: user, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def authenticate_request
    @current_user = current_user
  end

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role,
                                :first_name, :last_name, :gsm,
                                :country)
  end

  def profile_params
    params.require(:user).permit(:first_name, :last_name, :gsm,
                                :password, :password_confirmation)
  end

  def ensure_admin
    unless Current.user&.admin?
      render json: { error: "Bu işlem için admin yetkisi gerekli." }, status: :forbidden
    end
  end
end