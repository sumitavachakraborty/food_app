# frozen_string_literal: true

# table created for orders
class CreateOrders < ActiveRecord::Migration[6.1]
  def change
    create_table :orders do |t|
      t.references :restaurant, null: false, foreign_key: true
      t.integer :order_id
      t.float :total
      t.integer :quantity
      t.text :pincode
      t.references :user, foreign_key: true, on_delete: :destroy
      t.timestamps
    end
  end
end
