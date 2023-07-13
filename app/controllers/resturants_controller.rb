class ResturantsController < ApplicationController
  before_action :set_resturant, only: %i[show edit update destroy]
  before_action :require_user

  def show; end

  def index
    if params[:resturant_name].present?
      @resturant_name = params[:resturant_name]
      @resturant = Resturant.search_res(@resturant_name.downcase).records
      if @resturant.empty?
        flash[:warning] = 'Resturant not found'
        redirect_to resturants_path
      end
    else
      @resturant = Resturant.all
    end
    @nearest_locations = find_nearest_distance(@resturant, current_user.latitude, current_user.longitude)
    if @nearest_locations == 0
      render 'filter_locations'
    end
  end

  def new
    @resturant = Resturant.new
  end

  def edit; end

  def create
    @resturant = Resturant.new(resturant_params)
    if @resturant.save
      update_resturant_address
      flash[:success] = 'Resturant created successfully'
      redirect_to resturants_path
    else
      render :new
    end
  end

  def update
    if @resturant.update(resturant_params)
      update_resturant_address
      flash[:info] = 'Resturant updated successfully'
      redirect_to resturant_path
    else
      render :edit
    end
  end

  def destroy
    @resturant.destroy
    flash[:danger] = 'Resturant deleted successfully'
    redirect_to resturants_path
  end

  def filter_locations; end

  def search
    if params[:search].blank? && params[:category_id].blank?
      redirect_to resturants_path
    else
      if params[:category_id].present?
        reference_latitude = current_user.latitude
        reference_longitude = current_user.longitude
        @resturant = Category.search_category(Category.find(params[:category_id]).category_name).records
        category = Category.find(params[:category_id])
        params[:category_name] = category.category_name
      else
        @resturant = Resturant.all
      end
      if params[:search].present?
        @location = params[:search]
        @currentlocation = Geocoder.search(@location)
        if @currentlocation.first.present?
          reference_latitude = @currentlocation.first.latitude
          reference_longitude = @currentlocation.first.longitude
        else
          flash[:danger] = 'Search another location'
        end
      end
      @nearest_locations = find_nearest_distance(@resturant, reference_latitude, reference_longitude)
      if @nearest_locations == 0
        flash[:danger] = 'Location very far away, more than 10 k.m'
        redirect_to resturants_path
      end
      render 'index' unless params[:search].present?
    end
  end

  def distance_between(reslat, reslong, userlat, userlong)
    to_radians = ->(degrees) { degrees.to_f * Math::PI / 180 }
    earth_radius = 6371
    latitude_difference = to_radians.call(userlat) - to_radians.call(reslat)
    longitude_difference = to_radians.call(userlong) - to_radians.call(reslong)
    a = Math.sin(latitude_difference / 2)**2 + Math.cos(to_radians.call(reslat)) * Math.cos(to_radians.call(userlat)) * Math.sin(longitude_difference / 2)**2
    c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a))
    distance = earth_radius * c
    distance.round(2)
  end

  def markread
    @tempuser = User.find(params[:id])
    @tempuser.notifications.update_all(read: true)
    @notification = @tempuser.notifications.all
    @notification.delete_all
    respond_to do |format|
      format.js
    end
  end

  def gallery
    @resturant = Resturant.find(params[:resturant_id])
  end

  def attach_image
    @resturant = Resturant.find(params[:resturant_id])
    if params[:cover_image].present?
      @resturant.cover_image.attach(params[:cover_image])
    else
      flash[:warning] = 'Please select a image'
    end
    redirect_to resturant_gallery_path(@resturant)
  end

  private

  def find_nearest_distance(resturant, reference_latitude, reference_longitude)
    @nearest_locations = resturant.map do |res|
      distance = distance_between(res.latitude, res.longitude, reference_latitude, reference_longitude)
      return 0 if distance > 500

      [res, distance]
    end
    @nearest_locations.sort_by! { |_res, distance| distance }
    @nearest_locations = Kaminari.paginate_array(@nearest_locations).page(params[:page]).per(5)
  end

  def resturant_params
    params.require(:resturant).permit(:name, :address, :city, :latitude, :longitude, :category_id, cover_image: [])
  end

  def update_resturant_address
    result = Geocoder.search([@resturant.latitude, @resturant.longitude])
    @resturant.update(address: result.first&.address) if result.first.present?
  end

  def set_resturant
    @resturant = Resturant.find(params[:id])
  end
end
