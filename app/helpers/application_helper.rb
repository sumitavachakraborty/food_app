# frozen_string_literal: true

# Application Helper
module ApplicationHelper
  def get_coordinates(user, city)
    @results = Geocoder.search(city).first
    if @results.present?
      user.city = @results.city
      user.latitude, user.longitude = @results.coordinates
      user.save
      flash[:success] = 'location has been updated'
    else
      flash[:danger] = 'enter city not found'
    end
  end

  def coordinates_from_pincode(user, pincode)
    @results = Geocoder.search(pincode).first
    if @results.present?
      user.latitude, user.longitude = @results.coordinates
      user.save
      flash[:success] = 'location has been updated'
      redirect_to user
    else
      redirect_to change_address_user_path(user), danger: 'enter pincode not found'
    end
  end
end
