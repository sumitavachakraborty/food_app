class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_user, only: %i[show edit update destroy]
  before_action :same_user, only: %i[edit update]

  def index
    @user = User.order(created_at: :asc)
  end

  def show
    return unless @user.orders.present?

    @orders = @user.orders.order(created_at: :asc).page(params[:page]).per(5)
  end

  def new
    if logged_in?
      flash[:info] = 'You are already logged in.'
      redirect_to restaurants_path
    else
      @user = User.new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      results = Geocoder.search(@user.city)
      if results.first.present?
        coordinate = results.first.coordinates
        @user.latitude = coordinate[0]
        @user.longitude = coordinate[1]
        @user.save
      else
        flash[:notice] = 'enter city not found'
      end
      flash[:success] = 'Your account information was updated successfully'
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
        flash[:notice] = 'enter city not found'
      end
      session[:user_id] = @user.id
      session[:type] = 'user'
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
    
    # end
    @user.destroy
    session[:user_id] = nil if @user == current_user
    flash[:danger] = 'Account deleted successfully'
    redirect_to root_path
  end

  def image
    @user = User.find(session[:user_id])
    @user.images.attach(params[:user][:images])
    redirect_to @user
  end

  def makeadmin
    @tempuser = User.find(params[:id])
    @tempuser.toggle!(:admin)
    respond_to do |format|
      format.js
    end
  end

  def location
    @user = User.find(params[:user_id])
    if params[:city].present?
      @user.update(city: params[:city])
      redirect_to @user
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :city)
  end

  def set_user
    @user = User.find(params[:id])
  end

  def same_user
    if current_user != @user && !current_user.admin?
      flash[:danger] = 'Your can edit or delete your review'
      redirect_to @resturants_path
    end
  end
end
