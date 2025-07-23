class Api::V1::CommentsController < Api::V1::ApiController
  before_action :set_product, only: [:create, :destroy]
  before_action :set_comment, only: [:destroy]
  before_action :authorize_user, only: [:destroy]

  def create
    @comment = @product.comments.new(comment_params)
    @comment.user = @current_user
    if @comment.save
      render json: { message: "Yorumunuz başarıyla eklendi!", comment: @comment }, status: :created
    else
      render json: { error: "Yorum eklenirken bir hata oluştu.", errors: @comment.errors.full_messages }, status: :unprocessable_entity
    end
  end

  def destroy
    @comment.destroy
    render json: { message: "Yorum silindi." }, status: :ok
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_comment
    @comment = @product.comments.find(params[:id])
  end

  def comment_params
    params.require(:comment).permit(:content)
  end

  def authorize_user
    unless @current_user&.admin? || @current_user == @comment.user
      render json: { error: "Bu yorumu silme yetkiniz yok." }, status: :forbidden
    end
  end

  def comment_params
    params.require(:comment).permit(:content, :rating)
  end
end