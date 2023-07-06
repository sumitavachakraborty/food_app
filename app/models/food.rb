class Food < ApplicationRecord
  belongs_to :resturant
  has_one_attached :food_image
end
