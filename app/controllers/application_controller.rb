class ApplicationController < ActionController::Base
    add_flash_types :success, :warning, :danger, :info
    helper_method :current_user, :logged_in?
    # before_action :authenticate

    # def authenticate
    #     if session[:type] = "user"
    #         redirect_to '/user' if session[:id] != nil
    #     end
    # end

    def current_user
        @current_user ||= User.find(session[:user_id]) if session[:user_id]
    end

    def logged_in?
        !!current_user
    end

    def require_user
        if !logged_in?
            flash[:danger] = "You must log in to continue"
            redirect_to login_path
        end
    end
end
