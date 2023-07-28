# frozen_string_literal: true

# Resturants Controller
class ResturantsController < ApplicationController
  before_action :set_resturant, only: %i[show edit update destroy]
  before_action :require_user
  before_action :admin_user, only: %i[edit new update destroy]
  include ResturantsHelper

  def show; end

  def index
    if params[:resturant_name].present?
      search_resturant_by_name
      check_empty
    else
      @resturant = Resturant.all
    end
    @nearest_locations = find_nearest_distance(@resturant, current_user.latitude, current_user.longitude)
    check_user_empty_nearest_locations
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

  def markread
    @tempuser = User.find(params[:id])
    @notification = @tempuser.notifications.all
    @notification.delete_all
    respond_to(&:js)
  end

  def count
    @tempuser = User.find(params[:id])
    @tempuser.notifications.update_all(read: true)
    respond_to(&:js)
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

  def search
    return redirect_to resturants_path if search_and_category_blank?

    @resturant = filter_restaurants_by_category
    set_reference_coordinates
    change_coordinates if params[:search].present?
    @nearest_locations = find_nearest_distance(@resturant, @reference_latitude, @reference_longitude)

    handle_empty_nearest_locations

    render 'index' unless params[:search].present?
  end

  private

  def resturant_params
    params.require(:resturant).permit(:name, :address, :city, :latitude, :longitude, :category_id, cover_image: [])
  end

  def update_resturant_address
    result = Geocoder.search([@resturant.latitude, @resturant.longitude])
    @resturant.update(address: result.first&.address) if result.first.present?
  end

  def set_resturant
    @resturant = Resturant.find_by(id: params[:id])

    return unless @resturant.nil?

    flash[:danger] = "Resturant with ID #{params[:id]} not found."
    redirect_to resturants_path
  end
end
