# frozen_string_literal: true

# Orders Controller
class OrdersController < ApplicationController
  before_action :require_user, except: %i[index]
  before_action :find_resturant
  before_action :find_order, only: %i[edit update destroy]

  def index
    @food = @resturant.foods
  end

  def new; end

  def create
    cart_items = params[:cart_items]
    add_to_cart(cart_items)
    @order = create_order
    @order.delivery_address = current_user.city
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

  def add_to_cart(cart)
    @total_price = 0
    @quantity_array = []
    @food_name_array = []
    @price_array = []
    @total_quantity = 0
    cart.each do |_key, value|
      quantity = value['q'].to_i
      prices = value['p'].to_f
      food_names = value['n']
      @food_name_array << food_names
      @quantity_array << quantity
      @price_array << prices
      @total_price += (quantity * prices)
      @total_quantity += quantity
    end
  end

  def create_order
    Resturant.find(params[:resturant_id]).orders.create(quantity: @total_quantity, total: @total_price,
                                                        user_id: current_user.id,
                                                        foodname_array: @food_name_array,
                                                        foodquantity_array: @quantity_array,
                                                        food_price_array: @price_array)
  end

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
