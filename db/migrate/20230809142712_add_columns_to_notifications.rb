# frozen_string_literal: true

# changed user foreign key
class AddColumnsToNotifications < ActiveRecord::Migration[6.1]
  def change
    add_reference :notifications, :book_tables, optionals: true
    add_reference :notifications, :orders, optionals: true
  end
end
