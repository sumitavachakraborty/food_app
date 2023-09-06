# frozen_string_literal: true

# Application Controller
class ApplicationController < ActionController::Base
  add_flash_types :success, :warning, :danger, :info
  helper_method :current_user, :logged_in?, :notification_count

  def not_found_method
    render file: Rails.public_path.join('404.html'), status: :not_found, layout: false
  end

  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  def logged_in?
    !!current_user
  end

  def require_user
    return if logged_in?

    flash[:danger] = 'You must log in to continue'
    redirect_to login_path
  end

  def admin_user
    return if logged_in? && current_user.admin?

    flash[:danger] = 'Only admins can access this page'
    redirect_to resturants_path
  end

  def check_location
    return if current_user.address.present?

    flash[:danger] = 'Please enter your address'
    redirect_to user_path(current_user)
  end

  def notification_count
    Notification.find_notification_count(current_user)
  end
end
