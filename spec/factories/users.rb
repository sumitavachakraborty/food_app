# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Name }
    email { Faker::Internet.email }
    city { 'kolkata' }
  end
end
