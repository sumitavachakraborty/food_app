# frozen_string_literal: true

# Categories Controller
class CategoriesController < ApplicationController
  before_action :require_user, :admin_user

  def index
    @categories = Category.all
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(params.require(:category).permit(:category_name))
    if @category.save
      flash[:success] = 'Category created successfully'
      redirect_to categories_path
    else
      render :new
    end
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_path, danger: 'Category deleted successfully'
  end
end
