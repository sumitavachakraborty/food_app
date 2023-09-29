# frozen_string_literal: true

# BookTable Model
class BookTable < ApplicationRecord
  paginates_per 3
  belongs_to :user
  belongs_to :restaurant

  validate :book_date_cannotbe_in_the_past
  validates :book_time, presence: true
  validates :head_count, presence: true
  validates_uniqueness_of :book_date, scope: :resturant_id
  validate :book_date_timespan
  scope :show_booking, ->(user) { where(user_id: user.id) }

  def book_date_cannotbe_in_the_past
    errors.add(:book_date, 'must be selected') unless book_date.present?
    return unless book_date.present? && book_date < Date.today

    errors.add(:book_date, "can't be in the past")
  end

  def book_date_timespan
    return unless book_date.present? && book_date < Date.today + 5.days

    errors.add(:book_date, 'must be at least 5 days from today')
  end
end
