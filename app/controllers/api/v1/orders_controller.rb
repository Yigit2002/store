class Api::V1::OrdersController < Api::V1::ApiController
  # before_action :ensure_current_user
  before_action :set_order, only: [:cancel, :refund]

  def index
    order_ids = @current_user.orders.pluck(:id)
    render json: { orders: @current_user.orders }, status: :ok
    orders = @current_user.orders
  end

  def order_items
    order_items = OrderItem.where(order_id: params[:order_id])
    render json: { order_id: order_id }
  end
  
  def cancel
    if @order.present? && @order.preparing?
      @order.update(status: :cancelled)
      render json: { message: "Sipariş başarıyla iptal edildi." }, status: :ok
    elsif @order.cancelled?
      render json: { error: "Sipariş zaten iptal edilmiş." }, status: :unprocessable_entity
    else
      render json: { error: "Bu sipariş iptal edilemez." }, status: :unprocessable_entity
    end
  end

  def refund
    if @order.update(status: :refunded)
      render json: { message: "Sipariş iade edildi." }, status: :ok
    else
      render json: { error: "İade işlemi başarısız oldu." }, status: :unprocessable_entity
    end
  end

  private

  def ensure_current_user
    unless @current_user
      render json: { error: "Yetkisiz erişim." }, status: :unauthorized
    end 
  end
 
  def set_order
    @order = @current_user.orders.find_by(id: params[:id])
    render json: { error: "Sipariş bulunamadı." }, status: :not_found unless @order
  end
end