class Api::V1::SellerProductsController < ApplicationController
  before_action :set_seller_product, only: [:edit, :update, :destroy]
  before_action :ensure_seller, only: [:index, :create, :edit, :update, :destroy]

  def index
    @seller_products = Current.user.seller_products.includes(:product)
    render json: @seller_products, status: :ok
  end

  def create
    @seller_product = Current.user.seller_products.build(seller_product_params)

    if @seller_product.save
      render json: { message: "Ürün başarıyla oluşturuldu!", seller_product: @seller_product }, status: :created
    else
      render json: { errors: @seller_product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def edit
    render json: @seller_product, status: :ok
  end

  def update
    if @seller_product.update(seller_product_params)
      render json: { message: "Ürün başarıyla güncellendi!", seller_product: @seller_product }, status: :ok
    else
      render json: { errors: @seller_product.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @seller_product.destroy
    render json: { message: "Ürün başarıyla kaldırıldı!" }, status: :ok
  end

  private

  def set_seller_product
    @seller_product = Current.user.seller_products.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Bu ürüne erişim yetkiniz yok." }, status: :forbidden
  end

  def seller_product_params
    params.require(:seller_product).permit(:price, :stock)
  end

  def ensure_seller
    render json: { error: "Satıcı değilsiniz!" }, status: :forbidden unless Current.user&.seller?
  end
end