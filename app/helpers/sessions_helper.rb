# frozen_string_literal: true

# Sessions Helper
module SessionsHelper
  def check_validity
    (@user.token_expire.present? && @user.token_expire > Time.now) && @user.login_token == params[:token]
  end

  def mail_set_user
    @email = params[:session][:email]
    @token = SecureRandom.urlsafe_base64
    @login_link = "#{root_url}login_verify?token=#{@token}&email=#{@email}"
    @user.login_token = @token
    @user.token_expire = Time.now + 10.minutes
    @user.save
    UserMailer.confirmation_email(@user, @login_link).deliver_later
    redirect_to new_session_path, success: 'Link has been sent to your email address'
  end

  def check_user
    if @user
      mail_set_user
    else
      redirect_to new_session_path, danger: 'User Not Signed Up'
    end
  end

  def make_valid
    session[:user_id] = @user.id
    flash[:info] = 'Login successful'
    redirect_to restaurants_path
  end

  def find_user_auth(user)
    return [] if User.find_by(email: user.email).present?

    session[:user_id] = user.id
    check_access_token
  end

  private

  def check_access_token
    revoke_token(session[:access_token]) if session[:access_token].present?
    session[:access_token] = request.env['omniauth.auth'][:credentials][:token]
  end
end
