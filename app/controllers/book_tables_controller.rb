# frozen_string_literal: true

# BookTables Controller
class BookTablesController < ApplicationController
  before_action :require_user
  before_action :find_book_table, only: %i[destroy]
  before_action :set_restaurant, except: [:show]
  before_action :admin_user, only: %i[destroy]

  def index
    @book_tables = @restaurant.book_tables.show_booking(current_user)
  end

  def new
    @book_tables = BookTable.new
    @all_tables = @restaurant.book_tables
  end

  def create
    @book_tables = @restaurant.book_tables.new(table_params)
    @book_tables.user_id = current_user.id
    if @book_tables.save
      flash[:success] = 'Table Booked successfully'
      send_notification
      redirect_to restaurant_book_tables_path(@restaurant)
    else
      render :new
    end
  end

  def show
    @restaurant = Restaurant.all
    @book_table = BookTable.show_booking(current_user)
  end

  def destroy
    @book_table.destroy
    flash[:danger] = 'Booking deleted successfully'
    redirect_to restaurant_book_tables_path(@restaurant)
  end

  private

  def send_notification
    Notification.create(user_id: current_user.id,
                        message: "Booked table for #{@restaurant.name}, check details",
                        restaurant_id: @restaurant.id, book_table_id: @book_tables.id)
  end

  def find_book_table
    @book_table = BookTable.find(params[:id])
  end

  def set_restaurant
    @restaurant = Restaurant.find(params[:restaurant_id])
  end

  def table_params
    params.require(:book_table).permit(:book_date, :book_time, :head_count)
  end
end
