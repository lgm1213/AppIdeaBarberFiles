class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  # Changes to the importmap will invalidate the etag for HTML responses
  stale_when_importmap_changes

  helper_method :current_user

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def require_user
    redirect_to login_path, alert: "You must be logged in to do that" unless current_user
  end

  def require_shop_owner
    redirect_to root_path, alert: "You are not authorized to perform this action." unless current_user&.barber?
  end

  def find_shop_for_user(shop_id = params[:shop_id] || params[:id])
    if current_user.barber?
      current_user.shops.find(shop_id)
    elsif current_user.staff?
      shop = current_user.staff_shop
      raise ActiveRecord::RecordNotFound unless shop && shop.id.to_s == shop_id.to_s
      shop
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
