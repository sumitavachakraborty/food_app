# frozen_string_literal: true

# create table categories
class CreateCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :categories do |t|
      t.string :category_name
      t.timestamps
    end
  end
end
