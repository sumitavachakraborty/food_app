# frozen_string_literal: true

# Application Helper
module ApplicationHelper
  def get_coordinates(user)
    @results = Geocoder.search(user.city).first
    if @results.present?
      user.latitude, user.longitude = @results.coordinates
      user.address = @results.address
      user.save
    else
      flash[:notice] = 'enter city not found'
      redirect_to user_path(user)
    end
  end
end
