# frozen_string_literal: true

# create table reviews
class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.text :comment
      t.boolean :approval, default: false
      t.integer :rating
      t.references :restaurant, null: false, foreign_key: true
      t.string :review_images
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
  end
end
