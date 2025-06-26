class Api::V1::ApiController < ApplicationController
  include Authentication

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
  rescue_from StandardError, with: :render_internal_server_error

  before_action :set_current_user_from_token, only: [:create, :update]
  skip_before_action :verify_authenticity_token

  private

  def set_current_user_from_token
    auth_header = request.headers['Authorization']
    if auth_header && auth_header.start_with?('Bearer ')
      token = auth_header.split(' ')[1]
      begin
        decoded_token = JWT.decode(token, true, { algorithm: 'HS256' })
        @current_user = User.find(decoded_token[0]['user_id'])
      rescue JWT::DecodeError, ActiveRecord::RecordNotFound
        @current_user = nil
      end
    end
  end

  def render_not_found(exception)
    render json: { error: "Kaynak bulunamadı", message: exception.message }, status: :not_found
  end

  def render_parameter_missing(exception)
    render json: { error: "Eksik parametre", message: exception.message }, status: :unprocessable_entity
  end

  def render_internal_server_error(exception)
    render json: { error: "Sunucu hatası", message: exception.message }, status: :internal_server_error
  end

  def switch_locale 
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale) { yield }
  end
end 