# frozen_string_literal: true

# Foods Controller
class FoodsController < ApplicationController
  before_action :set_food, only: %i[edit update destroy]
  before_action :require_user, except: %i[index]
  before_action :find_restaurant

  def index
    @food = @restaurant.foods
  end

  def new
    @food = @restaurant.foods.new
  end

  def edit; end

  def create
    @food = @restaurant.foods.new(food_params)
    if @food.save
      flash[:success] = 'Food item created successfully'
      redirect_to restaurant_foods_path(@restaurant)
    else
      render :new
    end
  end

  def update
    if @food.update(food_params)
      flash[:info] = 'Food item updated successfully'
      redirect_to restaurant_foods_path(@restaurant)
    else
      render :edit
    end
  end

  def destroy
    @food.destroy
    flash[:danger] = 'Restaurant deleted successfully'
    redirect_to restaurant_foods_path(@restaurant)
  end

  private

  def food_params
    params.require(:food).permit(:food_name, :food_price, :food_image)
  end

  def set_food
    @food = Food.find(params[:id])
  end

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end
end
