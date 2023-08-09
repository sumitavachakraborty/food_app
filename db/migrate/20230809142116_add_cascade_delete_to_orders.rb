# frozen_string_literal: true

# changed user foreign key
class AddCascadeDeleteToOrders < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :orders, :users
    add_foreign_key :orders, :users, null: false, on_delete: :nullify
  end
end
