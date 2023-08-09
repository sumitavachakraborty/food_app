# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  paginates_per 4
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username, presence: true,
                       length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 110 },
                    format: { with: VALID_EMAIL_REGEX }
  # validates :city, presence: true
  has_secure_password

  has_one_attached :images
  has_many :orders, dependent: :nullify
  has_many :reviews, dependent: :nullify
  has_many :notifications, dependent: :destroy
  has_many :book_tables
  validate :city_presence

  def city_presence
    if city.present?
      location = Geocoder.search(city)
      return if location.first.present?

      errors.add(:city, 'entered is not valid')
    else
      errors.add(:city, 'must be present')
    end
  end
end
