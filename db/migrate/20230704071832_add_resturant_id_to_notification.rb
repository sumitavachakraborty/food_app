class AddResturantIdToNotification < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :resturant_id, :integer
  end
end
