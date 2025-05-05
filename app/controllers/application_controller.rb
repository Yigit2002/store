class ApplicationController < ActionController::Base
  include Authentication
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern
  before_action :set_categories, if: :authenticated?

  around_action :switch_locale

  helper_method :current_user

  def set_categories
    @categories = Category.all
  end

  def current_user
    if session[:sessionable_id]
        @current_user ||= User.find_by(id: session[:sessionable_id]) || Seller.find_by(id: session[:sessionable_id])
        Current.user = @current_user
    end
  end
  
  def switch_locale(&action)
    locale = params[:locale] || I18n.default_locale
    I18n.with_locale(locale, &action)
  end
end
