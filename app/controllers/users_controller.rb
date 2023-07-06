
class UsersController < ApplicationController
    before_action :set_user, only: [:show, :edit, :update, :destroy]
    before_action :require_user, only: [:edit, :update, :destroy]
    before_action :same_user, only: [:edit, :update]
    
    def index
       @user = User.order(created_at: :asc)
    end
  
    def show
        # NotificationsChannel.broadcast_to(current_user, notification)
        # binding.pry  
      # cookies.signed[:user_id] = @user.id
      # if notification.save
      #   NotificationsChannel.broadcast_to(@user, {data: notification})
      # end
    end
  
    def new
      if logged_in?
        flash[:info] = "You are already logged in."
        redirect_to restaurants_path
      else
        @user = User.new
      end
    end
    
    def edit
    end

    def update
      if @user.update(user_params)
        flash[:success] = "Your account information was updated successfully"
        redirect_to @user
      else
        render :edit
      end
    end

    def create
        @user = User.new(user_params)
        if @user.save
          results = Geocoder.search(@user.city)
          if results.first.present?
            coordinate = results.first.coordinates
            @user.latitude = coordinate[0]
            @user.longitude = coordinate[1]
            @user.save
          else
            flash[:notice] = "enter city not found"
          end
          session[:user_id] = @user.id
          session[:type] = "user"
          flash[:info] = "Welcome to the Zomato, #{@user.username}! You signed in successfully."
          redirect_to resturants_path
        else
          render :new
        end
    end

    def destroy
      # response = HTTParty.get('https://accounts.google.com/o/oauth2/revoke?token='+session[:access_token].to_s)
      # puts response
      # if response.code == 200
        # @user.destroy
        # session[:user_id] = nil if @user = current_user
        # flash[:danger] = "Account and all associated articles have been deleted"
        # redirect_to articles_path
      # end
    end
    
    def image
      @user = User.find(session[:user_id])
      # puts params[:user][:images]
      @user.images.attach(params[:user][:images])
      redirect_to @user
    end

    def makeadmin

      @tempuser = User.find(params[:id])
      @tempuser.toggle!(:admin)
      # puts @tempuser
      # redirect_to users_path
      
      respond_to do |format|
        format.js
      end
    end

    private
    def user_params
        params.require(:user).permit(:username, :email, :password,:city)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def same_user
      if current_user != @user && !current_user.admin?
        flash[:danger] = "Your can edit or delete your own article"
        redirect_to @user  
      end
    end
end
