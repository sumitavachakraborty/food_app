# frozen_string_literal: true

# Application Helper
module ApplicationHelper
  def get_coordinates(user)
    get_session(user)
    results = Geocoder.search(user.city)
    if results.first.present?
      coordinate = results.first.coordinates
      user.latitude = coordinate[0]
      user.longitude = coordinate[1]
      user.save
    else
      flash[:notice] = 'enter city not found'
    end
  end

  def get_session(user)
    session[:user_id] = user.id
  end
end
