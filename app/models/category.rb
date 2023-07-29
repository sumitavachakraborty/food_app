# frozen_string_literal: true

# Category Model
class Category < ApplicationRecord
  has_many :resturants
  validates :category_name, presence: true
end
