# frozen_string_literal: true

# add_column to resturants
class AddLocationToResturant < ActiveRecord::Migration[6.1]
  def change
    add_column :restaurants, :city, :string
    add_column :restaurants, :latitude, :string
    add_column :restaurants, :longitude, :string
  end
end
