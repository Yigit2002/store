class Api::V1::CardsController < ApplicationController
  before_action :set_card, only: [:show, :update_balance, :destroy]
  before_action :ensure_admin, only: [:update_balance]

  def index
    user = User.second
    @cards = user.cards
    render json: @cards, status: :ok
  end

  def show
    render json: @card, status: :ok
  end

  def create
    user = User.second
    @card = user.cards.build(card_params)
    if @card.save
      render json: { message: "Kart başarıyla eklendi.", card: @card }, status: :created
    else
      render json: { error: "Kart eklenemedi.", errors: @card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @card.destroy
    render json: { message: "Kart başarıyla silindi." }, status: :ok
  end

  def update_balance
    if @card.update(balance: params[:card][:balance])
      render json: { message: "Bakiye başarıyla güncellendi.", card: @card }, status: :ok
    else
      render json: { error: "Bakiye güncellenemedi.", errors: @card.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_card
    @card = Card.find(params[:id])
    render json: { error: "Kart bulunamadı." }, status: :not_found unless @card
  end

  def card_params
    params.require(:card).permit(:name, :number, :security_code, :expiry_date, Current.user&.admin? ? :balance : nil).compact
  end

  def ensure_admin
    render json: { error: "Bu işlem için yetkiniz yok." }, status: :unauthorized unless Current.user&.admin?
  end
end