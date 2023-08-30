# frozen_string_literal: true

# Order Model
class Order < ApplicationRecord
  paginates_per 4
  belongs_to :resturant
  belongs_to :user

  # validate :delivery_address_presence

  # def delivery_address_presence
  #   if delivery_address.present?
      
  #     errors.add(:city, 'entered is not valid')
  #   else
  #     errors.add(:city, 'must be present')
  #   end
  # end
end
