class Api::V1::UsersController < Api::V1::ApiController
  include ActionView::Helpers::NumberHelper
  # before_action :authenticate_request, only: [:me]

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

  def show
    render json: @current_user, status: :ok
  end

  def update_profile
    if user.update(profile_params)
      render json: user, status: :ok
    else
      render json: { errors: user.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

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
    unless @current_user&.admin?
      render json: { error: "Bu işlem için admin yetkisi gerekli." }, status: :forbidden
    end
  end
end