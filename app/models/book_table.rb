class BookTable < ApplicationRecord
  belongs_to :user
  belongs_to :resturant
  validate :book_date_cannotbe_in_the_past
  validates :book_time, presence: true
  validates :head_count, presence: true

  def book_date_cannotbe_in_the_past
    errors.add(:book_date, 'must be selected') unless book_date.present?
    return unless book_date.present? && book_date < Date.today

    errors.add(:book_date, "can't be in the past")
  end
end
