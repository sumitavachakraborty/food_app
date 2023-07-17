# frozen_string_literal: true

# Resturants Helper
module ResturantsHelper
  def distance_between(reslat, reslong, userlat, userlong)
    distance = Geocoder::Calculations.distance_between([reslat, reslong], [userlat, userlong])
    distance.round(2)
  end

  def find_nearest_distance(resturant, reference_latitude, reference_longitude)
    @nearest_locations = resturant.map do |res|
      distance = distance_between(res.latitude, res.longitude, reference_latitude, reference_longitude)
      return [] if distance > 500

      [res, distance]
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
    end
  end

  def check_empty
    return unless @resturant.empty?

    flash[:warning] = 'Resturant not found'
    redirect_to resturants_path
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

    flash[:danger] = 'Location very far away, more than 10 k.m'
    redirect_to resturants_path
  end

  def search_resturant_by_name
    @resturant_name = params[:resturant_name]
    @resturant = Resturant.search_res(@resturant_name.downcase).records
    check_empty
  end
end
