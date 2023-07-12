class User < ApplicationRecord
  paginates_per 4
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :username, presence: true,
                       uniqueness: { case_sensitive: false }, length: { minimum: 3, maximum: 25 }
  validates :email, presence: true, uniqueness: { case_sensitive: false }, length: { maximum: 110 },
                    format: { with: VALID_EMAIL_REGEX }
  has_secure_password

  has_one_attached :images
  has_many :orders, dependent: :destroy
  has_many :reviews
  has_many :notifications
  has_many :book_tables, dependent: :destroy
end
