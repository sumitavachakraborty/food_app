# frozen_string_literal: true

# Category Model
class Category < ApplicationRecord
  has_many :resturants, dependent: :destroy

  validates :category_name, presence: true

  scope :find_category_name, ->(resturant_id) { find(resturant_id.category_id).category_name }

  def self.category_name(resturant_id)
    Category.find_category_name(resturant_id)
  end
end
