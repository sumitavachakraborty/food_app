# frozen_string_literal: true

# Resturants Helper
module ResturantsHelper
  def distance_between(reslat, reslong, userlat, userlong)
    distance = Geocoder::Calculations.distance_between([reslat, reslong], [userlat, userlong])
    distance.round(2)
  end

  def find_nearest_distance(resturant, reference_latitude, reference_longitude)
    @nearest_locations = []
    resturant.each do |res|
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
      redirect_to resturants_path
    end
  end

  def check_empty
    return unless @resturant.empty?

    flash.now[:danger] = 'Resturant not found'
    @resturant = Resturant.all
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

    flash[:danger] = 'No such resturants found in this location'
    redirect_to resturants_path
  end

  def search_resturant_by_name
    @resturant_name = params[:resturant_name]
    @resturant = Resturant.search_res(@resturant_name.downcase).records
  end

  def filter_restaurants_by_category
    @resturant = Resturant.find_category(params[:category_id]) if params[:category_id].present?
    return unless @resturant.empty?

    flash.now[:danger] = 'NO resturants found in this category'
    @resturant = Resturant.all
  end

  def check_user_empty_nearest_locations
    return unless @nearest_locations.empty?

    flash[:danger] = 'No resturant found in your location'
    redirect_to current_user
  end
end
