# frozen_string_literal: true

FactoryBot.define do
  factory :restaurant do
    name { '6 Ballygunge Place' }
    address { 'Hindustan Club, Ramani Chatterji Road, Ballygunge, Kolkata, West Bengal, 700029, India' }
    latitude { '22.5192695' }
    longitude { '88.3606188' }
    category_id { 1 }
    cover_image { Rack::Test::UploadedFile.new(Rails.root.join('spec', 'fixtures', 'food2.jpg')) }
  end
end
