class OrdersController < ApplicationController
  before_action :require_user, except: [:show,:index]
  before_action :find_resturant, except: [:create,:new]
  # before_action :find_foods, only: [:new, :edit, :create, :update]
  # before_action :find_order, only: [:show, :edit, :update]

  
  def index
    @food = @resturant.foods
  end

  def show
  end

  def new
    @resturant = Resturant.find(params[:resturant_id])
  end

  def create
    # puts params[:cart_items]
    cart = params[:cart_items]
    @total = 0
    @quantit= []
    @name = []
    @price = []
    @quant = 0

    cart.each do |_key, value|
      quantity = value["q"].to_i
      pr = value["p"].to_f
      @food_name = value["n"]
      @name << @food_name
      @quantit << quantity
      @price << pr
      @total = @total + (quantity*pr)
      @quant = @quant + quantity
    end

    # binding.pry
    @order = Resturant.find(params[:resturant_id]).orders.create(quantity: @quant,total: @total,user_id: current_user.id,foodname_array: @name,foodquantity_array: @quantit,food_price_array: @price)
    @resturant = Resturant.find(params[:resturant_id])
    @order.delivery_address = current_user.city
    
    if @order.save!
      # flash[:success] = "Food item created successfully"
      redirect_to edit_resturant_order_path(@resturant,@order)
    end
      # binding.pry
    respond_to do |format|
      format.js
    end
  end

  def edit
    @order = Order.find(params[:id])
    @resturant = Resturant.find(params[:resturant_id])
  end

  def update
    @order = Order.find(params[:id])
    @resturant = Resturant.find(params[:resturant_id])
    if @order.update(params_order)
      flash[:info] = "Order placed successfully"
      OrderMailer.order_confirmation(current_user,@order).deliver_later
      Notification.create(user_id: current_user.id,message: 'Order placed, Please provide rating',resturant_id: @resturant.id)
      redirect_to resturant_orders_path(@resturant)
    else
      render :edit
    end
  end 

  def destroy
    @order = Order.find(params[:id])
    @order.destroy
    flash[:danger] = "Order Cancelled"
    redirect_to resturant_orders_path(@resturant)
  end
  

  private

  def params_order
    params.require(:order).permit(:quantity,:total,:user_id,:delivery_address ,foodname_array: [],foodquantity_array: [],food_price_array: [])
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
