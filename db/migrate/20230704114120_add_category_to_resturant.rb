# frozen_string_literal: true

# add column category
class AddCategoryToResturant < ActiveRecord::Migration[6.1]
  def change
    add_reference :restaurants, :category, optionals: true, on_delete: :nullify
  end
end
