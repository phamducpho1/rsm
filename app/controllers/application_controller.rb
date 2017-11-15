class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %i(name phone address sex birthday))
    devise_parameter_sanitizer.permit(:account_update, keys: %i(name phone address sex birthday))
  end

  def recent_products
    @recent_products ||= RecentProducts.new cookies
  end

  def last_viewed_product
    recent_products.reverse.second
  end
end
