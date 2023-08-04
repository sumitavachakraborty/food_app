# frozen_string_literal: true

# Orders Controller
class OrdersController < ApplicationController
  before_action :require_user
  before_action :find_resturant
  before_action :find_order, only: %i[edit update destroy]
  include OrdersHelper

  def index
    @food = @resturant.foods
  end

  def new; end

  def create
    cart_items = params[:cart_items]
    add_to_cart(cart_items)
    @order = create_order
    @order.delivery_address = current_user.address
    if @order.save!
      flash[:success] = 'Food item created successfully'
      redirect_to edit_resturant_order_path(@resturant, @order)
    end
    respond_to(&:js)
  end

  def edit; end

  def update
    if @order.update(params_order)
      flash[:info] = 'Order placed successfully'
      OrderMailer.order_confirmation(current_user, @order).deliver_later
      Notification.create(user_id: current_user.id, message: 'Order placed, Please provide rating',
                          resturant_id: @resturant.id)
      redirect_to resturant_orders_path(@resturant)
    else
      render :edit
    end
  end

  def destroy
    @order.destroy
    flash[:danger] = 'Order Cancelled'
    redirect_to resturant_orders_path(@resturant)
  end

  private

  def params_order
    params.require(:order).permit(:quantity, :total, :user_id, :delivery_address, foodname_array: [],
                                                                                  foodquantity_array: [],
                                                                                  food_price_array: [])
  end

  def find_resturant
    @resturant = Resturant.find(params[:resturant_id])
  end

  def find_order
    @order = Order.find(params[:id])
  end

  def find_foods
    @food = @restaurant.foods.all
  end
end
