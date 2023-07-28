# frozen_string_literal: true

# Order Model
class Order < ApplicationRecord
  paginates_per 4
  belongs_to :resturant
  belongs_to :user
  validates :delivery_address, presence: true
end
