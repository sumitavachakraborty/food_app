# frozen_string_literal: true

# changed bookTable foreign key
class RemoveBookTableFk < ActiveRecord::Migration[6.1]
  def change
    remove_foreign_key :book_tables, :users
    add_foreign_key :book_tables, :users, null: false, on_delete: :cascade
  end
end
