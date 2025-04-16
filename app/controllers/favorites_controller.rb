class FavoritesController < ApplicationController

  def index
    @products = Current.user.favorite_products
  end

  def create
    @favorite = Current.user.favorites.build(product_id: params[:product_id])
    if @favorite.save
      redirect_to product_path(params[:product_id]), notice: "Ürün favorilere eklendi."
    else
      redirect_to product_path(params[:product_id]), alert: @favorite.errors.full_messages.join(", ")
    end
  end

  def destroy
    @favorite = Current.user.favorites.find(params[:id])
    @favorite.destroy
    redirect_to product_path(@favorite.product_id), notice: "Ürün favorilerden çıkarıldı."
  end
end