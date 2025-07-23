class Api::V1::OrderItemsController < Api::V1::ApiController
  before_action :ensure_current_user
  before_action :set_order

  def index
    @order_items = @order.order_items
    render json: @order_items, status: :ok
  end

  private

  def ensure_current_user
    render json: { error: "Yetkisiz erişim." }, status: :unauthorized unless @current_user
  end

  def set_order
    @order = @current_user.orders.find_by(id: params[:order_id])
    render json: { error: "Sipariş bulunamadı." }, status: :not_found unless @order
  end
end