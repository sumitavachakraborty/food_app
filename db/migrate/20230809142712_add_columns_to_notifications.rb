# frozen_string_literal: true

# changed user foreign key
class AddColumnsToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_reference :notifications, :book_table, optionals: true, on_delete: :cascade
    add_reference :notifications, :orders, optionals: true
  end
end
