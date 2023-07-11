class ResturantsController < ApplicationController
  before_action :set_resturant, only: [:show,:edit,:update,:destroy]
  before_action :require_user, except: [:show]
  
  def show
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
    @nearest_locations = Kaminari.paginate_array(@nearest_locations).page(params[:page]).per(5)
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
    if params[:category_id].present? && params[:search].present?
      @resturant = Category.search_category(Category.find(params[:category_id]).category_name).records
      @location = params[:search]
      @currentlocation = Geocoder.search(@location)
      if @currentlocation.first.present?
        reference_latitude = @currentlocation.first.latitude
        reference_longitude = @currentlocation.first.longitude
        
        max_distance = 0 
        @nearest_locations = @resturant.map do |res|
          distance = distance_between(res.latitude, res.longitude,reference_latitude, reference_longitude)
          max_distance = max_distance.nil? ? distance : [max_distance, distance].max
          [res, distance]
        end
        if max_distance > 200
          flash[:danger] = "Location very far away, more than 10 k.m"
          redirect_to resturants_path
        else
          @nearest_locations.sort_by! { |res, distance| distance }
          @nearest_locations = Kaminari.paginate_array(@nearest_locations).page(params[:page]).per(2)
          category = Category.find(params[:category_id])
          params[:category_name] = category.category_name
          render 'search', params: { category_name: category.category_name }
        end 
      else
        flash[:danger] = "Search another location"
        render 'filter_locations'
      end
    elsif params[:category_id].present?
      @resturant = Category.search_category(Category.find(params[:category_id]).category_name).records
      category = Category.find(params[:category_id])
      params[:category_name] = category.category_name
      render 'filter_locations', params: { category_name: category.category_name }
    elsif params[:resturant_name].present?
      @resturant_name = params[:resturant_name]
      @resturant = Resturant.search_res(@resturant_name.downcase).records
      if @resturant.size<1
        flash[:warning] = "Resturant not found"
        redirect_to resturants_path
      else
        render :filter_locations
      end
    else  
      if params[:search].blank?
        redirect_to resturants_path
      else
        @location = params[:search]
        @currentlocation = Geocoder.search(@location)
        if @currentlocation.first.present?
          reference_latitude = @currentlocation.first.latitude
          reference_longitude = @currentlocation.first.longitude
          
          max_distance = 0 
          @nearest_locations = Resturant.all.map do |res|
            distance = distance_between(res.latitude, res.longitude,reference_latitude, reference_longitude)
            max_distance = max_distance.nil? ? distance : [max_distance, distance].max
            [res, distance]
          end
          if max_distance > 200
            flash[:danger] = "Location very far away, more than 10 k.m"
            redirect_to resturants_path
          else
            @nearest_locations.sort_by! { |res, distance| distance }
            @nearest_locations = Kaminari.paginate_array(@nearest_locations).page(params[:page]).per(2)
            render 'search'
          end 
        else
          flash[:danger] = "Search another location"
          redirect_to resturants_path
        end
      end
    end
  end

  def distance_between(reslat, reslong, userlat, userlong)
    def to_radians(degrees)
      degrees.to_f * Math::PI / 180
    end
    reslat_rad = to_radians(reslat)
    reslong_rad = to_radians(reslong)
    userlat_rad = to_radians(userlat)
    userlong_rad = to_radians(userlong)  
    earth_radius = 6371
    d_lat = userlat_rad - reslat_rad
    d_lon = userlong_rad - reslong_rad
    a = Math.sin(d_lat / 2) ** 2 + Math.cos(reslat_rad) * Math.cos(userlat_rad) * Math.sin(d_lon / 2) ** 2
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
      flash[:warning] = "Please select a image"
    end
    redirect_to resturant_gallery_path(@resturant)
  end

  private 

  def set_resturant
    @resturant = Resturant.find(params[:id])
  end
end
