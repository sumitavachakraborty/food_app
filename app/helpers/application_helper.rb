# frozen_string_literal: true

# Application Helper
module ApplicationHelper
  def get_coordinates(user)
    get_session(user)
    if @results.present?
      user.latitude, user.longitude = @results.coordinates
      user.address = @results.address
      user.save
    else
      flash[:notice] = 'enter city not found'
      redirect_to user_path(user)
    end
  end

  def get_session(user)
    session[:user_id] = user.id
    @results = Geocoder.search(user.city).first
  end
end
