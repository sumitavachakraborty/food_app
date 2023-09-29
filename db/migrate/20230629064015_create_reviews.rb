# frozen_string_literal: true

# create table reviews
class CreateReviews < ActiveRecord::Migration[6.1]
  def change
    create_table :reviews do |t|
      t.text :comment
      t.boolean :approval, default: false
      t.integer :rating
      t.references :restaurant, foreign_key: true, on_delete: :cascade
      t.string :review_images
      t.references :user, foreign_key: true, on_delete: :nullify

      t.timestamps
    end
  end
end
