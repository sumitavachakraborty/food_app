# frozen_string_literal: true

# Orders Controller
class OrdersController < ApplicationController
  before_action :require_user, :find_restaurant, :check_location, :check_distance
  before_action :find_order, only: %i[edit update destroy show]
  include OrdersHelper

  def index
    @food = @restaurant.foods
  end

  def new; end

  def create
    cart_items = params[:cart_items]
    add_to_cart(cart_items)
    @order = create_order
    @order.delivery_address = current_user.address
    if @order.save!
      flash[:success] = 'Food item created successfully'
      redirect_to edit_restaurant_order_path(@restaurant, @order)
    end
    respond_to(&:js)
  end

  def edit; end

  def show; end

  def update
    update_quantity
    if @order.update(params_order)
      OrderMailer.order_confirmation(current_user, @order).deliver_later
      Notification.create(user_id: current_user.id,
                          message: "Order placed for #{@restaurant.name}, check details",
                          restaurant_id: @restaurant.id, orders_id: @order.id)
      redirect_to restaurant_orders_path(@restaurant), info: 'Order placed successfully'
    else
      render :edit
    end
  end

  def destroy
    @order.destroy
    flash[:danger] = 'Order Cancelled'
    redirect_to restaurant_orders_path(@restaurant)
  end

  private

  def params_order
    params.require(:order).permit(:quantity, :total, :user_id, :delivery_address,
                                  foodname_array: [],
                                  foodquantity_array: [],
                                  food_price_array: [])
  end

  def find_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def find_order
    @order = Order.find(params[:id])
  end

  def find_foods
    @food = @restaurant.foods.all
  end
end
