# frozen_string_literal: true

# Sessions controller.
class SessionsController < ApplicationController
  include ApplicationHelper
  include SessionsHelper
  before_action :check_login, only: %i[new create]

  def new; end

  def create
    @user = User.find_by(email: params[:session][:email].downcase)
    check_user
  end

  def destroy
    session[:user_id] = nil
    session[:access_token] = nil
    redirect_to root_path, success: 'Logged out successfully'
  end

  def omniauth
    user = User.new(uid: request.env['omniauth.auth'][:uid]) do |u|
      get_omniauth_user(u)
    end
    if find_user_auth(user).empty?
      redirect_to new_session_path, danger: 'User already signed up, login again'
    else
      user.save!
      redirect_to user
    end
  end

  def verify
    @user = User.find_by_email(params[:email])
    if check_validity
      make_valid
    else
      @user.update(login_token: nil, token_expire: nil)
      session[:user_id] = nil
      flash.now[:danger] = 'Please Login again, session expired'
      render :new
    end
  end

  def revoke_token(token)
    response = HTTParty.post('https://accounts.google.com/o/oauth2/revoke',
                             query: { token: },
                             headers: { 'Content-Type' => 'application/x-www-form-urlencoded' })
    return unless response.code == 200
  end

  private

  def set_session
    session[:user_id] = user.id
  end

  def check_login
    redirect_to restaurants_path if logged_in?
  end

  def get_omniauth_user(user)
    user.username = request.env['omniauth.auth'][:info][:first_name]
    user.email = request.env['omniauth.auth'][:info][:email]
    user.password_digest = SecureRandom.hex(15)
  end
end
