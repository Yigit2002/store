class ApplicationController < ActionController::Base
  # include Authentication
  
  # allow_browser versions: :modern
  # before_action :set_categories, if: :authenticated?

  # around_action :switch_locale

  # helper_method :current_user

  def set_categories
    @categories = Category.all
  end

  skip_before_action :verify_authenticity_token

  def current_user
    @current_user ||= User.find_by(id: session[:user_id]) if session[:user_id]
  end

  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
