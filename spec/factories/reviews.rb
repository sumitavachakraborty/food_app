# frozen_string_literal: true

FactoryBot.define do
  factory :review do
    rating { 4 }
    comment { 'This restaurant is amazing!' }
    association :user, factory: :user
    association :restaurant, factory: :restaurant
  end
end
