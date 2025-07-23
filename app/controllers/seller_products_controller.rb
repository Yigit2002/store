class SellerProductsController < ApplicationController
  before_action :set_seller_product, only: [:edit, :update, :destroy]
  before_action :ensure_seller, only: [:index]

  def index
    @seller_products = Current.user.seller_products.includes(:product)
    render "my_products"
  end

  def edit
    render "edit"
  end

  def show
  end

  def update
    if @seller_product.update(seller_product_params)
      redirect_to seller_products_path, notice: "Ürün başarıyla güncellendi."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @seller_product.destroy
    redirect_to seller_products_path, notice: "Ürün başarıyla kaldırıldı."
  end

  private

  def set_seller_product
    @seller_product = Current.user.seller_products.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to seller_products_path, alert: "Bu ürüne erişim yetkiniz yok."
  end

  def seller_product_params
    params.require(:seller_product).permit(:price, :stock)
  end

  def ensure_seller
    unless Current.user&.seller?
      redirect_to root_path, alert: "Bu sayfaya yalnızca satıcılar erişebilir."
    end
  end
end