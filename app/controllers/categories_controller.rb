class CategoriesController < ApplicationController
  before_action :ensure_admin, only: [:index, :new]

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.savess
      redirect_to categories_path, notice: "Kategori başarıyla eklendi."
    else
      render :new, status: :unprocessable_entity
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def ensure_admin
    unless Current.user&.admin?
      redirect_to root_path, alert: "Bu işlem için admin yetkisi gereklidir."
    end
  end
end