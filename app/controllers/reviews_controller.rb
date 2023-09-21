# frozen_string_literal: true

# Reviews Controller
class ReviewsController < ApplicationController
  before_action :require_user, except: [:show]
  before_action :find_review, only: %i[update destroy approve edit]
  before_action :set_resturant
  before_action :same_user, only: %i[edit update destroy]

  def index; end

  def show; end

  def new
    @review = @resturant.reviews.new
  end

  def create
    @review = @resturant.reviews.new(review_params)
    @review.user_id = current_user.id
    if @review.save
      flash[:success] = 'Review was successfully added, will be visible after approval'
      redirect_to resturant_path(@resturant)
    else
      render :new
    end
  end

  def edit; end

  def update
    if @review.update(review_params)
      flash[:warning] = 'Updated review'
      redirect_to resturant_path(@resturant)
    else
      render :edit
    end
  end

  def destroy
    @review.destroy
    redirect_to resturant_path(@resturant)
  end

  def approve
    @review.toggle!(:approval)

    respond_to(&:js)
  end

  private

  def find_review
    @review = Review.find(params[:id])
  end

  def set_resturant
    @resturant = Resturant.find(params[:resturant_id])
  end

  def review_params
    params.require(:review).permit(:comment, :rating, review_images: [])
  end

  def same_user
    return unless current_user == @user

    flash[:danger] = 'Your can edit or delete your review'
    redirect_to resturant_path(@resturant)
  end
end
