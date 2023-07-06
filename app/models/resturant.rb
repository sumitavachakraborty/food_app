class Resturant < ApplicationRecord
    # before_save { self.name = name.downcase}
    has_many_attached :cover_image
    has_many :foods, dependent: :destroy
    has_many :orders, dependent: :destroy
    has_many :reviews, dependent: :destroy
    has_one :category
    has_many :book_tables, dependent: :destroy
end
