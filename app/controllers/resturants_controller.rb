class ResturantsController < ApplicationController
  before_action :set_resturant, only: [:show,:edit,:update,:destroy]
  before_action :require_user, except: [:show]
  
  def show
    # @user = current_user
    # NotificationsChannel.broadcast_to(
    #   current_user,
    #   title: 'New things!',
    #   body: 'All the news fit to print'
    # )
  end

  def index
    @resturant = Resturant.all
    reference_latitude = current_user.latitude
    reference_longitude = current_user.longitude

    @nearest_locations = @resturant.map do |res|
      distance = distance_between(res.latitude, res.longitude,current_user.latitude, current_user.longitude)
      [res, distance]
    end
    @nearest_locations.sort_by! { |res, distance| distance }
  end

  def new
    @resturant = Resturant.new
  end

  def edit
  end

  def create
    @resturant = Resturant.new(params.require(:resturant).permit(:name,:address,:city,:latitude,:longitude,:category_id,cover_image: []))
    if @resturant.save
      result = Geocoder.search([@resturant.latitude, @resturant.longitude])
      if result.first.present? 
        @resturant.address = result.first&.address
        @resturant.save 
      end
      flash[:success] = "resturant created successfully"
      redirect_to resturants_path
    else
      render :new
    end
  end

  def update
    if @resturant.update(params.require(:resturant).permit(:name,:address,:city,:latitude,:longitude,:category_id,cover_image: []))
      result = Geocoder.search([@resturant.latitude, @resturant.longitude])
      if result.first.present? 
        @resturant.address = result.first&.address
        @resturant.save 
      end
      flash[:info] = "Resturant updated successfully"
      redirect_to resturant_path
    else
      render :edit
    end
  end

  def destroy
    @resturant.destroy
      flash[:danger] = "Resturant deleted successfully"
      redirect_to resturants_path
  end

  def filter_locations
  end

  def search 
    if params[:resturant_name].present?
      @city_name = params[:resturant_name]
      @resturant = Resturant.where("LOWER(name) LIKE ?", "%#{@city_name.downcase}%")
      render :filter_locations 
    else  
      if params[:search].blank?
        redirect_to resturants_path
      else
        @query = params[:search]
        @currentlocation = Geocoder.search(@query)
        if @currentlocation.first.present?
          reference_latitude = @currentlocation.first.latitude
          reference_longitude = @currentlocation.first.longitude
          
          
          @nearby_location = Resturant.all.map do |res|
            distance = distance_between(res.latitude, res.longitude,reference_latitude, reference_longitude)
            [res, distance]
          end
          @nearby_location.sort_by! { |res, distance| distance }
          # @resturant = Resturant.where("LOWER(name) LIKE ?", "%#{@query.downcase}%")
          render 'search' 
        else
          flash[:success] = "search another"
          redirect_to resturants_path
        end
      end
    end
  end

  def distance_between(reslat, reslong, userlat, userlong)
    # Convert degrees to radians
    def to_radians(degrees)
      degrees.to_f * Math::PI / 180
    end

    reslat_rad = to_radians(reslat)
    reslong_rad = to_radians(reslong)
    userlat_rad = to_radians(userlat)
    userlong_rad = to_radians(userlong)
  
    # Earth radius in kilometers
    earth_radius = 6371
  
    # Difference of latitudes and longitudes
    d_lat = userlat_rad - reslat_rad
    d_lon = userlong_rad - reslong_rad
  
    # Haversine formula
    a = Math.sin(d_lat / 2) ** 2 + Math.cos(reslat_rad) * Math.cos(userlat_rad) * Math.sin(d_lon / 2) ** 2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    distance = earth_radius * c
    distance.round(2)  # Rounded to 2 decimal places
    
  end

  def markread
    @tempuser = User.find(params[:id])
    @tempuser.notifications.update_all(read: true)
    @notification = @tempuser.notifications.all
    @notification.delete_all
    # binding.pry
    respond_to do |format|
      format.js
    end
  end

  private 

  def set_resturant
    @resturant = Resturant.find(params[:id])
  end
end
