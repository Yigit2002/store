class CartsController < ApplicationController
  before_action :set_cart

  include ActionView::Helpers::NumberHelper

  def show
    @cart_items = @cart.cart_items
    @addresses = Current.user.addresses
  end

  def update_quantity
    @cart_item = CartItem.find(params[:id])
    new_quantity = params[:quantity].to_i

    if new_quantity > 0
      @cart_item.update(quantity: new_quantity)
      redirect_to cart_path
    else
      @cart_item.destroy
      redirect_to cart_path, notice: "Ürün sepetten kaldırıldı."
    end
  end

  def add_to_cart
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_by(product: product)

    if cart_item
      cart_item.quantity += params[:quantity].to_i
    else
      cart_item = @cart.cart_items.build(product: product, quantity: params[:quantity].to_i)
    end

    respond_to do |format|
      if cart_item.quantity <= product.inventory_count && cart_item.save
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("messages", "<div class='bg-green-100 text-green-800 p-4 rounded-md mb-4 fixed top-0 w-full z-50' id='notice_#{Time.now.to_i}'>Ürün sepete eklendi.</div><script>setTimeout(() => {document.getElementById('notice_#{Time.now.to_i}').remove();}, 3000);</script>"),
            turbo_stream.update("cart_items_count", "<span class='text-lg text-gray-600'>#{Current.user.cart.cart_items.sum(:quantity)}</span>")
          ]
        end
        format.html { redirect_to products_path, notice: "Ürün sepete eklendi." } # Fallback için
      else
        format.turbo_stream do
          render turbo_stream: [
            turbo_stream.append("messages", "<div class='bg-red-100 text-red-800 p-4 rounded-md mb-4 fixed top-0 w-full z-50' id='alert_#{Time.now.to_i}'>Ürün sepete eklenemedi. Stok yetersiz veya geçersiz adet.</div><script>setTimeout(() => {document.getElementById('alert_#{Time.now.to_i}').remove();}, 3000);</script>")
          ]
        end
        format.html { redirect_to products_path, alert: "Ürün sepete eklenemedi. Stok yetersiz veya geçersiz adet." } # Fallback için
      end
    end
  end

  def remove_from_cart
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy
    redirect_to cart_path, notice: "Ürün sepetten kaldırıldı."
  end

  def clear_cart
    @cart.cart_items.destroy_all
    redirect_to cart_path, notice: "Sepetinizdeki tüm ürünler silindi."
  end

  def checkout
    total_price = @cart.cart_items.sum { |item| item.product.price * item.quantity }
    @address = Current.user.addresses.find_by(id: params[:address_id])

    if Current.user.balance >= total_price
      # Stok ve bakiye kontrolü
      @cart.cart_items.each do |item|
        product = item.product
        if product.inventory_count < item.quantity
          redirect_to cart_path, alert: "#{product.name} için yeterli stok yok."
          return
        end
      end

      # Satın alma işlemi
      @cart.cart_items.each do |item|
        product = item.product
        product.update!(inventory_count: product.inventory_count - item.quantity)
      end

      Current.user.update!(balance: Current.user.balance - total_price)
      @cart.cart_items.destroy_all
      redirect_to products_path, notice: "Satın alma işlemi başarıyla tamamlandı."
    else
      redirect_to cart_path, alert: "Bakiyeniz yetersiz!"
    end
  end

  private

  def set_cart
    @cart = Current.user.cart || Current.user.create_cart
  end
end