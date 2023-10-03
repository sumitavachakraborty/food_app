# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Name }
    email { Faker::Internet.email }
    city { 'kolkata' }
    password { 'password456' }
    address { '5/4 b.t road, khardah' }
  end
end
