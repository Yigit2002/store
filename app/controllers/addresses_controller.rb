# app/controllers/addresses_controller.rb
class AddressesController < ApplicationController
  before_action :set_address, only: [:show, :edit, :update, :destroy]

  def index
    @addresses = Current.user.addresses
  end

  def show
  end

  def new
    @address = Current.user.addresses.build
  end

  def create
    @address = Current.user.addresses.build(address_params)
    if @address.save
      redirect_to addresses_path, notice: "Adres başarıyla oluşturuldu."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @address.update(address_params)
      redirect_to addresses_path, notice: "Adres başarıyla güncellendi."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @address.destroy
    redirect_to addresses_path, notice: "Adres başarıyla silindi."
  end

  private

  def set_address
    @address = Current.user.addresses.find(params[:id])
  end

  def address_params
    params.require(:address).permit(:title, :body)
  end
end