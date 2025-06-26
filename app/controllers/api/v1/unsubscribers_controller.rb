class Api::UnsubscribeController < ApplicationController
  before_action :set_subscriber, only: [:destroy]

  def destroy
    @subscriber.destroy
    render json: { message: "Abonelikten çıkıldı." }, status: :ok
  rescue ActiveRecord::RecordNotFound
    render json: { error: "Abonelik bulunamadı." }, status: :not_found
  end

  private

  def set_subscriber
    @subscriber = Subscriber.find_by_token_for(:unsubscribe, params[:token])
  end
end