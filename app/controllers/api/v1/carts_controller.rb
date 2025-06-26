class Api::V1::CartsController < ApplicationController
  before_action :set_cart
  include ActionView::Helpers::NumberHelper

  def show
    user = User.second
    cart_items = @cart.cart_items
    addresses = user.addresses
    seller_products = cart_items.includes(:seller_product).map(&:seller_product)
    render json: {
      cart_items: cart_items.as_json(include: { seller_product: { include: :product } })
    }, status: :ok
  end

  def update_quantity
    cart_item = @cart.cart_items.find(params[:id])
    new_quantity = params[:quantity].to_i

    if new_quantity > 0
      if cart_item.update(quantity: new_quantity)
        render json: { message: "Ürün miktarı güncellendi.", cart_item: cart_item }, status: :ok
      else
        render json: { error: "Ürün miktarı güncellenemedi." }, status: :unprocessable_entity
      end
    else
      cart_item.destroy
      render json: { message: "Ürün sepetten kaldırıldı." }, status: :ok
    end
  end

  def add_to_cart
    seller_product = SellerProduct.find(params[:seller_product_id])
    cart_item = @cart.cart_items.find_by(seller_product_id: seller_product.id)

    if cart_item
      cart_item.quantity += params[:quantity].to_i
    else
      cart_item = @cart.cart_items.build(quantity: params[:quantity].to_i, seller_product_id: seller_product.id)
    end

    if cart_item.quantity <= cart_item.seller_product&.stock && cart_item.save
      render json: {
        message: "Ürün sepete eklendi.",
        cart_item: cart_item,
        cart_items_count: @cart.cart_items.sum(:quantity)
      }, status: :ok
    else
      render json: { error: "Ürün sepete eklenemedi. Stok yetersiz veya geçersiz adet." }, status: :unprocessable_entity
    end
  end

  def remove_from_cart
    cart_item = @cart.cart_items.find(params[:id])
    cart_item.destroy
    render json: { message: "Ürün sepetten kaldırıldı." }, status: :ok
  end

  def clear_cart
    @cart.cart_items.destroy_all
    render json: { message: "Sepetinizdeki tüm ürünler silindi." }, status: :ok
  end

  def checkout
    user = User.second
    total_price = @cart.cart_items.sum { |item| item.seller_product.price * item.quantity }
    address = user.addresses.find_by(id: params[:address_id])

    unless address
      return render json: { error: "Geçerli bir adres seçilmeli." }, status: :unprocessable_entity
    end

    if user.balance >= total_price
      @cart.cart_items.each do |item|
        seller_product = item.seller_product
        if seller_product.stock >= item.quantity
          seller_product.update!(stock: seller_product.stock - item.quantity)
        else
          return render json: { error: "#{item.seller_product.product.name} ürünü için yeterli stok yok!" }, status: :unprocessable_entity
        end
      end

      Current.user.update!(balance: Current.user.balance - total_price)
      order = Order.create!(user: Current.user)
      @cart.cart_items.each do |item|
        OrderItem.create!(
          order: order,
          seller_product: item.seller_product,
          quantity: item.quantity
        )
      end

      @cart.cart_items.destroy_all
      render json: { message: "Satın alma işlemi başarıyla tamamlandı.", order: order.as_json(include: { order_items: { include: :seller_product } }) }, status: :ok
    else
      render json: { error: "Bakiyeniz yetersiz!" }, status: :unprocessable_entity
    end
  end

  private

  def set_cart
    user = User.second
    @cart = user.cart || Current.user.create_cart
  end

  def ensure_authenticated
    unless Current.user
      render json: { error: "Kimlik doğrulama gerekli." }, status: :unauthorized
    end
  end
end