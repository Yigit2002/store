class Api::V1::CategoriesController < Api::V1::ApiController
  before_action :ensure_admin, only: [:new]
  before_action :set_category, only: [:show, :update, :destroy]

  def index
    @categories = Category.all
    render json: @categories
  end

  def new
    @category = Category.new
    render json: @category
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      render json: @category, status: :created
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def show
    render json: @category
  end

  def update
    if @category.update(category_params)
      render json: @category
    else
      render json: @category.errors, status: :unprocessable_entity
    end
  end

  def destroy
    @category.destroy
    render json: { message: "Kategori silindi." }, status: :ok
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def ensure_admin
    unless @current_user&.admin?
      render json: { error: "Bu işlem için admin yetkisi gereklidir.", status: :unauthorized }, status: :unauthorized
    end
  end
end