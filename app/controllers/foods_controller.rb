class FoodsController < ApplicationController
  before_action :set_food, only: %i[show edit update destroy]
  before_action :require_user, except: %i[show index]
  before_action :find_resturant

  def show; end

  def index
    @food = @resturant.foods
  end

  def new
    @food = @resturant.foods.new
  end

  def edit; end

  def create
    @food = @resturant.foods.new(food_params)
    if @food.save
      flash[:success] = 'Food item created successfully'
      redirect_to resturant_foods_path(@resturant)
    else
      render :new
    end
  end

  def update
    if @food.update(food_params)
      flash[:info] = 'Food item updated successfully'
      redirect_to resturant_foods_path(@resturant)
    else
      render :edit
    end
  end

  def destroy
    @food.destroy
    flash[:danger] = 'Resturant deleted successfully'
    redirect_to resturant_foods_path(@resturant)
  end

  private

  def food_params
    params.require(:food).permit(:food_name, :food_price, :food_image)
  end

  def set_food
    @food = Food.find(params[:id])
  end

  def find_resturant
    @resturant = Resturant.find(params[:resturant_id])
  end
end
