class CardsController < ApplicationController
  before_action :set_card, only: [:edit_balance, :update_balance, :destroy]
  before_action :ensure_admin, only: [:edit_balance, :update_balance]

  def index
    @cards = Current.user.cards
  end

  def new
    @card = Current.user.cards.build
  end

  def create
    @card = Current.user.cards.build(card_params)
    if @card.save
      flash[:notice] = "Kart başarıyla eklendi."
      redirect_to cards_path
    else
      flash[:alert] = "Kart eklenemedi."
      render :new
    end
  end

  def edit_balance
    # Sadece admin görür
  end

  def destroy 
    @card.destroy
    flash[:notice] = "Kart başarıyla silindi."
    redirect_to cards_path, status: :see_other
  end

  def update_balance
    if @card.update(balance: params[:card][:balance])
      flash[:notice] = "Bakiye başarıyla güncellendi."
      redirect_to admin_cards_path
    else
      flash[:alert] = "Bakiye güncellenemedi."
      render :edit_balance
    end
  end

  private

  def set_card
    @card = Card.find(params[:id])
  end

  def card_params
    params.require(:card).permit(:name, :number, :security_code, :expiry_date, Current.user&.admin? ? :balance : nil).compact
  end

  def ensure_admin
    redirect_to root_path, alert: "Bu işlem için yetkiniz yok." unless Current.user&.admin?
  end
end