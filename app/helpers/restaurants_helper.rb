# frozen_string_literal: true

# Restaurants Helper
module RestaurantsHelper
  def distance_between(reslat, reslong, userlat, userlong)
    distance = Geocoder::Calculations.distance_between([reslat, reslong], [userlat, userlong])
    distance.round(2)
  end

  def find_nearest_distance(restaurant, reference_latitude, reference_longitude)
    @nearest_locations = []
    restaurant.each do |res|
      distance = distance_between(res.latitude, res.longitude, reference_latitude, reference_longitude)

      @nearest_locations << [res, distance] if distance < 20
    end
    @nearest_locations.sort_by! { |_res, distance| distance }
    @nearest_locations = Kaminari.paginate_array(@nearest_locations).page(params[:page]).per(5)
  end

  def change_coordinates
    @location = params[:search]
    @currentlocation = Geocoder.search(@location)
    if @currentlocation.first.present?
      @reference_latitude = @currentlocation.first.latitude
      @reference_longitude = @currentlocation.first.longitude
    else
      flash[:danger] = 'Search another location'
      redirect_to restaurants_path
    end
  end

  def check_empty
    return unless @restaurant.empty?

    flash.now[:danger] = 'Restaurant not found'
  end

  def search_and_category_blank?
    params[:search].blank? && params[:category_id].blank?
  end

  def set_reference_coordinates
    @reference_latitude = current_user.latitude
    @reference_longitude = current_user.longitude
  end

  def handle_empty_nearest_locations
    return unless @nearest_locations.empty?

    flash.now[:danger] = 'No such restaurants found in this location'
  end

  def search_restaurant_by_name
    @restaurant_name = params[:restaurant_name]
    @restaurant = Restaurant.search_res(@restaurant_name.downcase).records
  end

  def filter_restaurants_by_category
    if params[:category_id].present?
      session[:category_id] = params[:category_id]
      @restaurant = Category.find(params[:category_id]).restaurants
    end
    return unless @restaurant.empty?

    flash.now[:danger] = 'No restaurants found in this category'
    @restaurant = Restaurant.all
  end

  def check_user_empty_nearest_locations
    return unless @nearest_locations.empty?

    flash[:danger] = 'No restaurant found in your location'
    redirect_to current_user
  end
end
