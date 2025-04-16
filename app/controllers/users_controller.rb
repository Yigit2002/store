class UsersController < ApplicationController

  include ActionView::Helpers::NumberHelper

  def index
    @users = User.all
  end

  def update_balance
    @user = User.find(params[:id])
    new_balance = params[:balance].to_d

    if new_balance >= 0 && @user.update(balance: new_balance)
      redirect_to users_path, notice: "#{@user.email_address} kullanıcısının bakiyesi güncellendi: #{number_to_currency(new_balance, unit: 'TL', format: '%n%u', separator: ',', delimiter: '.')}"
    else
      redirect_to users_path, alert: "Bakiye güncellenemedi. Bakiye sıfırdan küçük olamaz veya başka bir hata oluştu."
    end
  end

  private

  def ensure_admin
    unless Current.user&.admin?
      redirect_to root_path, alert: "Bu işlem için admin yetkisi gereklidir."
    end
  end
end