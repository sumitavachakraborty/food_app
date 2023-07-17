# frozen_string_literal: true

# BookTables Controller
class BookTablesController < ApplicationController
  before_action :require_user
  before_action :set_resturant

  def index
    @book_tables = @resturant.book_tables.all
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
      redirect_to resturant_book_tables_path(@resturant)
    else
      render :new
    end
  end

  def show
    @book_table = BookTable.find(params[:id])
  end

  private

  def set_resturant
    @resturant = Resturant.find(params[:resturant_id])
  end

  def table_params
    params.require(:book_table).permit(:book_date, :book_time, :head_count)
  end
end
