class Api::V1::UsersController < ApplicationController
  include ActionView::Helpers::NumberHelper

  def index
    users = User.all
    render json: users, status: :ok
  end

  def update_balance
    user = User.find(params[:id])
    new_balance = params[:balance].to_d

    if new_balance >= 0 && user.update(balance: new_balance)
      render json: {
        message: "#{user.email} kullanıcısının bakiyesi güncellendi: #{number_to_currency(new_balance, unit: 'TL', format: '%n%u', separator: ',', delimiter: '.')}",
        user: user
      }, status: :ok
    else
      render json: {
        error: "Bakiye güncellenemedi. Bakiye sıfırdan küçük olamaz veya başka bir hata oluştu."
      }, status: :unprocessable_entity
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

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation, :role,
                                :first_name, :last_name, :gsm,
                                :addresses, :city, :country, :balance)
  end

  def profile_params
    params.require(:user).permit(:first_name, :last_name, :gsm,
                                :addresses, :city, :country, :password, :password_confirmation)
  end

  def ensure_admin
    unless Current.user&.admin?
      render json: { error: "Bu işlem için admin yetkisi gerekli." }, status: :forbidden
    end
  end
end