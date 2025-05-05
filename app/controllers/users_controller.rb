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

  def show_profile
    @user = current_user
  end
  
  # Profil düzenleme sayfası için
  def edit_profile
    @user = current_user
  end
  
  # Profil güncelleme işlemi için
  def update_profile
    @user = Current.user
    
    if @user.update(profile_params)
      redirect_to profile_path, notice: 'Profiliniz başarıyla güncellendi.'
    else
      render :edit_profile
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address, :password, :password_confirmation, :role, 
                                :first_name,:telefon_numarasi, :last_name,:balance)
  end
  
  def profile_params
    params.require(:user).permit(:first_name, :last_name, :addresses, 
                                :city,:country, :password, :password_confirmation,:telefon_numarasi)
  end

  def ensure_admin
    unless Current.user&.admin?
      redirect_to root_path, alert: "Bu işlem için admin yetkisi gereklidir."
    end
  end
end