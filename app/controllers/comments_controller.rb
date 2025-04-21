class CommentsController < ApplicationController
  before_action :set_product
  before_action :set_comment, only: :destroy
  before_action :authorize_user, only: :destroy

  def create
    @comment = @product.comments.new(comment_params)
    @comment.user = Current.user

    if @comment.save
      flash[:notice] = "Yorumunuz başarıyla eklendi!"
      redirect_to product_path(@product)
    else
      flash[:alert] = "Yorum eklenirken bir hata oluştu."
      redirect_to product_path(@product)
    end
  end

  def destroy
    @comment.destroy
    flash[:notice] = "Yorum silindi."
    redirect_to product_path(@product), status: :see_other
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def set_comment
    @comment = @product.comments.find(params[:id])
  end

  def authorize_user
    unless @comment.user == Current.user || Current.user.admin?
      flash[:alert] = "Bu yorumu silme yetkiniz yok."
      redirect_to product_path(@product), status: :forbidden
    end
  end

  def comment_params
    params.require(:comment).permit(:content, :rating)
  end
end