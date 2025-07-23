class Api::V1::UnsubscribeController < Api::V1::ApiController
  before_action :set_subscriber, only: [:destroy]

  def destroy
    @subscriber.destroy
    render json: { message: "Abonelikten çıkıldı." }, status: :ok
  end

  private

  def set_subscriber
    @subscriber = Subscriber.find_by(id: params[:id])
  end
end