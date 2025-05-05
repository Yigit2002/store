class RegistrationsController < ApplicationController
  allow_unauthenticated_access

  def new
    @user = User.new 
  end

  def create
    @user = User.new(user_params)
    if @user.save
      if params[:become_seller] == '1'
        @user.create_seller!(name: @user.first_name)
      end
      redirect_to root_path, notice: "Kayıt başarılı!"
    else
      render :new
    end
  end

  private

  def user_params
    params.require(:user).permit(:email_address,:password,:password_confirmation,:first_name,:last_name,:telefon_numarasi)
  end
end