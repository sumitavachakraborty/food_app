# frozen_string_literal: true

# add column to user
class AddLocationToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :city, :string
    add_column :users, :latitude, :string
    add_column :users, :longitude, :string
  end
end
