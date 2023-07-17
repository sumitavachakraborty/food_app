# frozen_string_literal: true

# Review Model
class Review < ApplicationRecord
  belongs_to :user
  belongs_to :resturant
  has_many_attached :review_images
  validates :rating, presence: true
  validates :comment, length: { minimum: 3, maximum: 45 }
  validate :validate_image_format

  def validate_image_format
    return unless review_images.attached?

    review_images.each do |image|
      errors.add(:review_images, 'must be a JPEG/PNG image') unless image.content_type.in?(%w[image/jpeg image/png])
    end
  end
end
