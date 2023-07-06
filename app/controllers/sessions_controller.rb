class SessionsController < ApplicationController
    def new
    end

    def create
        @user = User.find_by(email: params[:session][:email].downcase)
        # if user && user.authenticate(params[:session][:password])
        #     session[:user_id] = user.id
        #     flash[:info] = "Login successful" 
        #     redirect_to user
        # else
        #     flash.now[:danger] = "Invalid credentials"
        #     render :new, status: :unprocessable_entity
        # end

        if @user
          @email=params[:session][:email]
          @token= SecureRandom.urlsafe_base64 
          @login_link = "#{root_url}/login_verify?token=#{@token}&email=#{@email}"    
          @user.login_token = @token
          @user.token_expire = Time.now + 2.minutes
          @user.save
          UserMailer.confirmation_email(@user,@login_link).deliver_now
        else
          flash.now[:danger] = "User Not Signed Up"
          render :new
        end
    end

    def destroy
        session[:user_id] = nil
        flash[:info] = "Logged out successfully"
        redirect_to root_path
    end

    def login
        user = User.find_by(login_token: params[:token])

        if user && user.login_token_expires_at > Time.now
          # Log in the user
          session[:user_id] = user.id
          cookies.signed[:user_id] = user.id
          user.update(login_token: nil, login_token_expires_at: nil) # Reset the token and expiration time after successful login
          redirect_to resturants_path, notice: "Logged in successfully!"
        elsif user
          redirect_to login_path, alert: "The login link has expired. Please request a new one."
        else
          redirect_to login_path, alert: "Invalid login token"
        end
    end

    def omniauth
        # user = request.env['omniauth.auth']
        # session[:user_id] = user.id
        # redirect_to root_path
        user =User.find_or_create_by(uid: request.env['omniauth.auth'][:uid],provider: request.env['omniauth.auth'][:provider]) do |u|
            u.username = "#{request.env['omniauth.auth'][:info][:first_name]} #{request.env['omniauth.auth'][:info][:last_name]}"
            u.email = request.env['omniauth.auth'][:info][:email]
            u.password = SecureRandom.hex(15)
        end

        session[:access_token]=request.env['omniauth.auth'].credentials.token

        puts session[:access_token]

          if user
            session[:user_id] =user.id
            flash[:info] = "Login successful" 
            redirect_to user
          else
            flash.now[:danger] = "Invalid credentials"
            render :new
          end
    end

    def verify
        puts params
        
        @user = User.find_by_email(params[:email])
        puts @user.token_expire
        
        if (@user.token_expire.present? && @user.token_expire>Time.now) && @user.login_token==params[:token]
          session[:user_id] = @user.id
          flash[:info] = "Login successful" 
          redirect_to resturants_path
        else 
          @user.update(login_token: nil, token_expire: nil)
          session[:user_id] = nil
          flash.now[:danger] = "Please Login again"
          render :new
        end
    end
end