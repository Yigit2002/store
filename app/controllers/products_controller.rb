class ProductsController < ApplicationController
  before_action :ensure_seller, only: [:new,:create, :edit, :update, :destroy, :my_products]
  before_action :set_product, only: [:edit, :update, :destroy]
  before_action :ensure_product_owner, only: [:edit, :update, :destroy]

  def index
    @products = Product.includes(:seller_products).all
    if params[:category_id]
      @category = Category.find(params[:category_id])
      @products = @category.products
    else
      @products = Product.all
    end
  end

  def show
    @product = Product.find(params[:id])
  end

  def new
    @product = Product.new
    @categories = Category.all
  end
  
  def create
    @product = Product.new(product_params)
    if @product.save
      SellerProduct.create!(
        product: @product,
        user: Current.user,
        price: params[:product][:price],
        stock: params[:product][:stock]
      )
      redirect_to @product, notice: 'Ürün başarıyla eklendi.'
    else
      render :new, status: :unprocessable_entity
    end
  end
  
  def edit
    @product = Product.find(params[:id])
  end

  def update
    @product = Product.find(params[:id])
    if @product.update(product_params)
      redirect_to @product
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @product = Product.find(params[:id])
    @product.destroy
    redirect_to root_path, notice: "Ürüm başarıyla kaldırıldı"
  end

  def my_products
    @seller_product = Current.user.seller_products.includes(:product).map(&:product)
  end
  
  def select_seller
    @product = Product.find(params[:id])
    seller_product = @product.seller_products.find_by(user_id: params[:seller_id])
  
    if seller_product
      selected_inventory = seller_product.stock
      selected_price = seller_product.price
  
      if selected_inventory > 0
        # Sepete ekle
        cart = Current.user.cart || Current.user.create_cart
        cart_item = cart.cart_items.find_or_initialize_by(seller_product_id: seller_product.id)
        cart_item.quantity ||= 0
        cart_item.quantity += 1
   
        # Stok kontrolü
        if selected_inventory >= cart_item.quantity
          if cart_item.save
            redirect_to cart_path, notice: "Ürün sepete eklendi!"
          else
            redirect_to @product, alert: "Sepete eklenemedi: #{cart_item.errors.full_messages.join(', ')}"
          end
        else
          redirect_to @product, alert: "#{seller_products.user.full_name} için yeterli stok yok!"
        end
      else
        redirect_to @product, alert: "Seçilen satıcıda stok kalmadı!"
      end
    else
      redirect_to @product, alert: "Geçersiz satıcı seçimi!"
    end
  rescue ActiveRecord::RecordNotFound
    redirect_to @product, alert: "Seçilen satıcı bu ürün için geçerli değil!"
  end


  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :featured_image, :category_id)
  end


  def ensure_seller
    unless Current.user&.seller?
      redirect_to root_path, alert: "Bu işlem için yetkiniz yok."
    end
  end

end
