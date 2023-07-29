# frozen_string_literal: true

# Application Helper
module ApplicationHelper
  def get_coordinates(user)
    get_session(user)
    results = Geocoder.search(user.city)
    if results.first.present?
      user.latitude, user.longitude = results.first.coordinates
      user.save
    else
      flash[:notice] = 'enter city not found'
      redirect_to user_path(user)
    end
  end

  def get_session(user)
    session[:user_id] = user.id
  end
end
