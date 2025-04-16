class CartsController < ApplicationController
  before_action :set_cart

  include ActionView::Helpers::NumberHelper

  def show
    @cart_items = @cart.cart_items
  end

  def add_to_cart
    product = Product.find(params[:product_id])
    cart_item = @cart.cart_items.find_by(product: product)

    if cart_item
      cart_item.quantity += params[:quantity].to_i
    else
      cart_item = @cart.cart_items.build(product: product, quantity: params[:quantity].to_i)
    end

    if cart_item.quantity <= product.inventory_count && cart_item.save
      redirect_to cart_path, notice: "Ürün sepete eklendi."
    else
      redirect_to products_path, alert: "Ürün sepete eklenemedi. Stok yetersiz veya geçersiz adet."
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