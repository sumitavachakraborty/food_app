class PagesController < ApplicationController
  def home
      redirect_to resturants_path if logged_in?
  end
end
