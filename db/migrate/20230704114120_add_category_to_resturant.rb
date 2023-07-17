# frozen_string_literal: true

# add column category
class AddCategoryToResturant < ActiveRecord::Migration[6.1]
  def change
    add_column :resturants, :category_id, :integer
  end
end
