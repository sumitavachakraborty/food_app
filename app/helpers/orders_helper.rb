# frozen_string_literal: true

# Orders Helper
module OrdersHelper
  def add_to_cart(cart)
    @total_price = 0
    @quantity_array = []
    @food_name_array = []
    @price_array = []
    @total_quantity = 0
    create_cart(cart)
  end

  def create_cart(cart)
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

  def update_quantity
    foodquantity_params = params[:order][:foodquantity_array]
    foodquantity_array = foodquantity_params.values.map(&:to_h)
    foodquantity_array.each_with_index do |food_params, index|
      @order.foodquantity_array[index] = food_params['food_quantity']
    end
  end
end
