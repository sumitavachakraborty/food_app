# frozen_string_literal: true

# Users Controller
class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy location makeadmin change_address]
  before_action :require_user, only: %i[show edit update destroy]
  before_action :same_user, only: %i[show edit update destroy]
  before_action :admin_user, only: %i[index]
  include ApplicationHelper

  def index
    @user = User.order(created_at: :asc)
  end

  def show
    @restaurant = Restaurant.all
    @book_table = BookTable.show_booking(@user).page(params[:page])
    return unless @user.orders.present?

    @orders = @user.orders.order(created_at: :desc).page(params[:page])
  end

  def new
    if logged_in?
      flash[:info] = 'You are already logged in.'
      redirect_to restaurants_path
    else
      @user = User.new
    end
  end

  def create
    @user = User.new(user_params)
    if @user.save
      get_coordinates(@user, @user.city)
      redirect_to new_session_path, success: "#{@user.username}! You signed in successfully,
                                                 Please log in to continue"
    else
      render :new
    end
  end

  def edit; end

  def update
    if @user.update(user_params)
      flash[:success] = 'Your account information was updated successfully'
      redirect_to @user
    else
      render :edit
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
    @user.toggle!(:admin)
    respond_to(&:js)
  end

  def change_address; end

  def location
    Restaurant.get_address(params, @user)
    coordinates_from_pincode(@user, params[:pincode]) if params[:pincode].present?
  end

  def admin_login; end

  def check_admin
    @user = User.find_by(email: params[:email].downcase)
    if @user&.admin? && @user&.authenticate(params[:password])
      session[:user_id] = @user.id
      redirect_to @user
    else
      redirect_to admin_login_users_path, danger: 'Invalid login details'
    end
  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :city, :address)
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
    redirect_to users_path
  end
end
