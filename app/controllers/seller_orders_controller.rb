class SellerOrdersController < ApplicationController
  before_action :set_order, only: [:update]

  def index
    @orders = Order
                .joins(order_items: :seller_product)
                .where(seller_products: { user_id: Current.user.id })
                .distinct
                .includes(order_items: { seller_product: :product }, user: {})

    @order_items = @orders.flat_map(&:order_items)
  end

  def update
    if @order.update(order_params)
      redirect_to seller_orders_path, notice: "Sipariş durumu güncellendi."
    else
      redirect_to seller_orders_path, alert: "Güncelleme başarısız oldu."
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])

    # Güvenlik: Sadece kendi ürününün olduğu siparişleri güncelleyebilsin
    unless @order.order_items.any? { |item| item.seller_product.user_id == Current.user.id }
      redirect_to seller_orders_path, alert: "Bu siparişi güncellemeye yetkiniz yok."
    end
  end

  def order_params
    params.require(:order).permit(:status)
  end
end
