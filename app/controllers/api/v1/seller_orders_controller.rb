class Api::V1::SellerOrdersController < Api::V1::ApiController
  before_action :set_order, only: [:update]

  def index
    @orders = Order.joins(:order_items => :seller_product)
                  .where(seller_products: { user_id:   @current_user.id })
                  .distinct
                  .includes(order_items: { seller_product: :product }, user: {})
    render json: @orders, status: :ok
  end

  def update
    if @order.update(order_params)
      render json: { message: "Sipariş durumu güncellendi." }, status: :ok
    else
      render json: { error: "Güncelleme başarısız oldu.", errors: @order.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:status)
  end
end