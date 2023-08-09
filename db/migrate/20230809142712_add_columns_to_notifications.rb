# frozen_string_literal: true

# changed user foreign key
class AddColumnsToNotifications < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :notifications, :users
    add_foreign_key :notifications, :users, null: false, on_delete: :cascade
  end
end
