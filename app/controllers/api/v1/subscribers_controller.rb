class Api::V1::SubscribersController < Api::V1::ApiController
  before_action :set_product, only: [:create]

  def create
    @subscriber = @product.subscribers.where(subscriber_params).first_or_create
    render json: { message: "Abonelik oluşturuldu." }, status: :created
  end

  private

  def set_product
    @product = Product.find(params[:product_id])
  end

  def subscriber_params
    params.require(:subscriber).permit(:email)
  end
end