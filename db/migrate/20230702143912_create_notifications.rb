# frozen_string_literal: true

# create table notification
class CreateNotifications < ActiveRecord::Migration[6.1]
  def change
    create_table :notifications do |t|
      t.references :user, null: false, foreign_key: true, on_delete: :cascade
      t.text :message
      t.boolean :read, default: false
      t.references :restaurant, null: false, foreign_key: true
      t.timestamps
    end
  end
end
