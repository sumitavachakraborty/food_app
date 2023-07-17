# frozen_string_literal: true

class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :resturant, null: false, foreign_key: true
      t.integer :order_id
      t.float :total
      t.integer :quantity
      t.references :user, foreign_key: true
      t.timestamps
    end
  end
end
