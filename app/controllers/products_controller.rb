class ProductsController < ApplicationController
  before_action :ensure_seller, only: [:new, :create, :edit, :update, :destroy]
  before_action :set_product, only: [:edit, :update, :destroy]
  before_action :ensure_product_owner, only: [:edit, :update, :destroy]
  before_action :ensure_seller, only: [:my_products]

  def index
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
    @product.seller = Current.user
    if @product.save
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
    redirect_to root_path
  end

  def my_products
    @products = Current.user.products
  end

  private


  private

  def set_product
    @product = Product.find(params[:id])
  end

  def product_params
    params.require(:product).permit(:name, :description, :featured_image, :inventory_count, :category_id, :price)
  end

  def ensure_seller
    unless Current.user.seller?
      redirect_to root_path, alert: "Bu işlem için satıcı olmanız gerekiyor."
    end
  end

  def ensure_product_owner
    unless @product.seller == Current.user
      redirect_to root_path, alert: "Bu ürünü düzenleme yetkiniz yok."
    end
  end
end
