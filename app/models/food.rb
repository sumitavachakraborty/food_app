# frozen_string_literal: true

# Food Model
class Food < ApplicationRecord
  belongs_to :resturant
  has_one_attached :food_image
  validates :food_name, presence: true,
                        length: { minimum: 3, maximum: 20 }
  validates :food_price, presence: true, numericality: { greater_than: 0, less_than: 4000 }
end
