# frozen_string_literal: true

# Restaurants Controller
class RestaurantsController < ApplicationController
  before_action :set_restaurant, only: %i[show edit update destroy]
  before_action :require_user
  before_action :admin_user, only: %i[edit new update destroy]
  before_action :check_location, except: %i[count]
  include RestaurantsHelper

  def show
    @all_review = @restaurant.reviews.where(approval: true)
  end

  def index
    session[:category_id] = nil
    if params[:restaurant_name].present?
      search_restaurant_by_name
      check_empty
    else
      @restaurant = Restaurant.all
    end
    @nearest_locations = find_nearest_distance(@restaurant, current_user.latitude, current_user.longitude)
  end

  def new
    @restaurant = Restaurant.new
  end

  def edit; end

  def create
    @restaurant = Restaurant.new(restaurant_params)
    if @restaurant.save
      update_restaurant_address
      flash[:success] = 'Restaurant created successfully'
      redirect_to restaurants_path
    else
      render :new
    end
  end

  def update
    if @restaurant.update(restaurant_params)
      update_restaurant_address
      flash[:info] = 'Restaurant updated successfully'
      redirect_to restaurant_path
    else
      render :edit
    end
  end

  def destroy
    @restaurant.destroy
    flash[:danger] = 'Restaurant deleted successfully'
    redirect_to restaurants_path
  end

  def filter_locations; end

  def markread
    @tempuser = User.find(params[:id])
    @notification = @tempuser.notifications.all
    @notification.delete_all
    respond_to(&:js)
  end

  def count
    @tempuser = User.find(params[:id])
    @tempuser.notifications.update_all(read: true)
    respond_to(&:js)
  end

  def gallery
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def attach_image
    @restaurant = Restaurant.find(params[:restaurant_id])
    if params[:cover_image].present?
      @restaurant.cover_image.attach(params[:cover_image])
    else
      flash[:warning] = 'Please select a image'
    end
    redirect_to restaurant_gallery_path(@restaurant)
  end

  def search
    return redirect_to restaurants_path if search_and_category_blank?

    @restaurant = Restaurant.all
    filter_restaurants_by_category
    set_reference_coordinates
    change_coordinates if params[:search].present?
    @nearest_locations = find_nearest_distance(@restaurant, @reference_latitude, @reference_longitude)
    handle_empty_nearest_locations

    render 'index' unless params[:search].present?
  end

  private

  def restaurant_params
    params.require(:restaurant).permit(:name, :address, :city, :latitude, :longitude, :category_id, cover_image: [])
  end

  def update_restaurant_address
    result = Geocoder.search([@restaurant.latitude, @restaurant.longitude])
    @restaurant.update(address: result.first&.address) if result.first.present?
  end

  def set_restaurant
    @restaurant = Restaurant.find_by(id: params[:id])

    return unless @restaurant.nil?

    flash[:danger] = "Restaurant with ID #{params[:id]} not found."
    redirect_to restaurants_path
  end
end
