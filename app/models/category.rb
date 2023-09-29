# frozen_string_literal: true

# Category Model
class Category < ApplicationRecord
  has_many :restaurants, dependent: :nullify

  validates :category_name, presence: true

  def self.category_name(resturant_id)
    Category.find(resturant_id.categories_id).category_name
  end
end
