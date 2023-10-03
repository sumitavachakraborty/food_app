# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    username { Faker::Name }
    email { Faker::Internet.email }
    city { 'kolkata' }
    latitude { '22.703727' }
    longitude { '88.3853786' }
    password { 'password456' }
    address { '5/4 b.t road, khardah' }
  end
end
