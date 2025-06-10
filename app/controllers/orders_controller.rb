class OrdersController < ApplicationController
  before_action :ensure_current_user

  def index
    order_ids = Current.user.orders.pluck(:id)
    @order_items =  OrderItem.where(order_id: order_ids)
  end


   def cancel
    @order = Current.user.orders.find_by(id: params[:id])
    if @order.present? && @order.preparing?
      @order.update(status: :cancelled)
      redirect_to orders_path, notice: "Sipariş başarıyla iptal edildi."
    elsif @order.cancelled?
      redirect_to orders_path, alert: "Sipariş zaten iptal edilmiş"
    else
      redirect_to orders_path, alert: "Bu sipariş iptal edilemez."
    end
  end

  def refund
  @order = Current.user.orders.find_by(id: params[:id])
  if @order.update(status: "refunded")
    redirect_to @order, notice: "Sipariş iade edildi."
  else
    redirect_to @order, alert: "İade işlemi başarısız oldu."
  end
end

  private

  def ensure_current_user
    redirect_to root_path, alert: "Bu sayfaya yalnızca giriş yapmış kullanıcılar erişebilir." unless Current.user 
  end
end 