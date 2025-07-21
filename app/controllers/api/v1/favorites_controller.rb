class Api::V1::FavoritesController < Api::V1::ApiController
  before_action :set_product, only: [:create, :destroy]

  def index
    user = User.second
    @products = user.favorite_products
    render json: @products, status: :ok
  end

  def create
    @favorite = @current_user.favorites.build(product_id: params[:product_id])
    if @favorite.save
      render json: { message: "Ürün favorilere eklendi.", favorite: @favorite }, status: :created
    else
      render json: { error: @favorite.errors.full_messages.join(", ") }, status: :unprocessable_entity
    end
  end

  def destroy
    @favorite = @current_user.favorites.find(params[:id])
    @favorite.destroy
    render json: { message: "Ürün favorilerden çıkarıldı." }, status: :ok
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end
end