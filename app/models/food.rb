class Food < ApplicationRecord
  belongs_to :resturant
  has_one_attached :food_image
  validates :food_name, presence: true
  validates :food_price, presence: true
end
