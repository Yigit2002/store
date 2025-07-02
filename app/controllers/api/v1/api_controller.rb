class Api::V1::ApiController < ActionController::API
  include ApiAuthentication

  rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
  rescue_from ActionController::ParameterMissing, with: :render_parameter_missing
  rescue_from StandardError, with: :render_internal_server_error

  private
  
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