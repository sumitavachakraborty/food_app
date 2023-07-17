# frozen_string_literal: true

class MakeNameAndQuantityArrayInOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :foodname_array, :text, array: true, default: []
    add_column :orders, :foodquantity_array, :integer, array: true, default: []
    add_column :orders, :food_price_array, :float, array: true, default: []
  end
end
