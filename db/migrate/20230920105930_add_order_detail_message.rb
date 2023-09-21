# frozen_string_literal: true

# changed notifications column
class AddOrderDetailMessage < ActiveRecord::Migration[6.1]
  def change
    add_column :notifications, :order_id, :integer
    add_column :notifications, :booktable_id, :integer
  end
end
