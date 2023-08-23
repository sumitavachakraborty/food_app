# frozen_string_literal: true

# Application Helper
module ApplicationHelper
  def get_coordinates(user, city)
    @results = Geocoder.search(city).first
    if @results.present?
      user.city = city
      user.latitude, user.longitude = @results.coordinates
      user.address = @results.address
      user.save
      flash[:success] = 'location has been updated'
    else
      flash[:danger] = 'enter city not found'
    end
  end
end
