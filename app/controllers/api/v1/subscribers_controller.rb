class Api::V1::SubscribersController < ApplicationController
  before_action :set_product, only: [:create]

  def create
    @subscriber = @product.subscribers.where(subscriber_params).first_or_create
    render json: { message: "Abonelik oluşturuldu." }, status: :created
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Ürün bulunamadı." }, status: :not_found
  end

  def subscriber_params
    params.require(:subscriber).permit(:email)
  end
end