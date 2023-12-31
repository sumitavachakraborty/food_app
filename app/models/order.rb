# frozen_string_literal: true

# Order Model
class Order < ApplicationRecord
  paginates_per 4
  belongs_to :restaurant
  belongs_to :user
end
