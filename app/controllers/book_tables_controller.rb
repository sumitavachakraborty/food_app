# frozen_string_literal: true

# BookTables Controller
class BookTablesController < ApplicationController
  before_action :require_user
  before_action :find_book_table, only: %i[destroy]
  before_action :set_resturant, except: [:show]
  before_action :admin_user, only: %i[destroy]

  def index
    @book_tables = @resturant.book_tables.show_booking(current_user)
  end

  def new
    @book_tables = BookTable.new
    @all_tables = @resturant.book_tables
  end

  def create
    @book_tables = @resturant.book_tables.new(table_params)
    @book_tables.user_id = current_user.id
    if @book_tables.save
      flash[:success] = 'Table Booked successfully'
      send_notification
      redirect_to resturant_book_tables_path(@resturant)
    else
      render :new
    end
  end

  def show
    @resturant = Resturant.all
    @book_table = BookTable.show_booking(current_user)
  end

  def destroy
    @book_table.destroy
    flash[:danger] = 'Booking deleted successfully'
    redirect_to resturant_book_tables_path(@resturant)
  end

  private

  def send_notification
    Notification.create(user_id: current_user.id,
                        message: "Booked table for #{@resturant.name}, check details",
                        resturant_id: @resturant.id, booktable_id: @book_tables.id)
  end

  def find_book_table
    @book_table = BookTable.find(params[:id])
  end

  def set_resturant
    @resturant = Resturant.find(params[:resturant_id])
  end

  def table_params
    params.require(:book_table).permit(:book_date, :book_time, :head_count)
  end
end
