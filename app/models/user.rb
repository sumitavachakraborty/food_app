# frozen_string_literal: true

# User Model
class User < ApplicationRecord
  paginates_per 4
  VALID_EMAIL_REGEX = /\A[A-Za-z0-9]+[._-]{0,1}[a-zA-Z0-9]+@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i
  validate :city_presence
  validates :username, presence: true,
                       length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 110 },
                    format: { with: VALID_EMAIL_REGEX }
  has_secure_password

  has_one_attached :images
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :nullify
  has_many :book_tables, dependent: :destroy
  has_many :notifications, dependent: :destroy

  def city_presence
    return unless city.present?

    location = Geocoder.search(city)
    return if location.first.present?

    errors.add(:city, 'entered is not valid')
  end
end
