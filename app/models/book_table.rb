class BookTable < ApplicationRecord
    belongs_to :user
    belongs_to :resturant
    validate :book_date_cannotbe_in_the_past
    validates :book_time, presence: true
    validates :head_count, presence: true

    def book_date_cannotbe_in_the_past
        if !book_date.present?
            errors.add(:book_date, "must be selected")
        end
        if book_date.present? && book_date < Date.today
            errors.add(:book_date, "can't be in the past")
        end
    end
end
