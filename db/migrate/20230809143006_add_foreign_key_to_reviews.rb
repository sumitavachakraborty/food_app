# frozen_string_literal: true

# changed user foreign key
class AddForeignKeyToReviews < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :reviews, :users
    add_foreign_key :reviews, :users, null: false, on_delete: :nullify
  end
end
