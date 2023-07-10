class Review < ApplicationRecord
    belongs_to :user
    belongs_to :resturant
    has_many_attached :review_images
    validates :rating, presence: true
    validates :comment, length: {minimum: 3, maximum: 45}
end
