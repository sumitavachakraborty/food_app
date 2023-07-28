# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  include ApplicationHelper
  before_action :set_user, only: %i[show edit update destroy]
  before_action :require_user, only: %i[show edit update destroy]
  before_action :same_user, only: %i[show edit update]
  before_action :admin_user, only: %i[index]

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
      get_coordinates(@user)
      flash[:success] = 'Your account information was updated successfully'
      redirect_to @user
    else
      render :edit
    end
  end

  def create
    @user = User.new(user_params)
    @user.city = 'kolkata'
    if @user.save
      get_coordinates(@user)
      session[:user_id] = @user.id
      flash[:info] = "Welcome to the Zomato, #{@user.username}! You signed in successfully."
      redirect_to resturants_path
    else
      render :new
    end
  end

  def destroy
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
    respond_to(&:js)
  end

  def location
    @user = User.find_by(id: params[:user_id])
    return unless params[:city].present?

    @user.update(city: params[:city])
    get_coordinates(@user)
    redirect_to @user
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :city)
  end

  def set_user
    @user = User.find_by(id: params[:id])
    return unless @user.nil?

    flash[:danger] = "user with ID #{params[:id]} not found."
    redirect_to users_path
  end

  def same_user
    return unless current_user != @user

    flash[:danger] = 'Your can edit or delete your review'
    redirect_to root_path
  end
end
