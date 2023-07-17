# rubocop:disable all
# frozen_string_literal: true

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

# seeds.rb

# User data
users_data = [
  {
    username: 'sumitava',
    email: 'chakrabortysumitava@gmail.com',
    password: 'password123',
    city: 'sodepore',
    latitude: '22.703727',
    longitude: '88.3853786'
  },
  {
    username: 'sumitava1111',
    email: 'sumitava@example.com',
    password: 'password456',
    city: 'sodepore',
    latitude: '22.703727',
    longitude: '88.3853786',
    admin: true
  }
]

# Create users
users_data.each do |user_data|
  User.create!(user_data)
end

categories = [
  { category_name: 'Multi Cuisine' },
  { category_name: 'Barbecues' },
  { category_name: 'Cafe' }
]

categories.each do |category_attrs|
  Category.create!(category_attrs)
end

# Seed resturants
resturants = [
  {
    name: 'Barbeque Nation',
    address: 'Sodepur, Khardaha, Barrackpore, North 24 Parganas, West Bengal, 700114, India',
    latitude: '22.7013927',
    longitude: '88.371923',
    category_id: 2,
    cover_image: 'food/food1.jpg'
  },
  {
    name: 'Mainland China',
    address: 'Rowland Row, Ho Chi Minh Sarani, Kolkata, West Bengal, 700020, India',
    latitude: '22.5369841',
    longitude: '88.3569412',
    category_id: 1,
    cover_image: 'food/food2.jpg'
  },
  {
    name: 'Chowman',
    address: 'CF Block, Sector I, Bidhannagar, North 24 Parganas, West Bengal, 700064, India',
    latitude: '22.5953422',
    longitude: '88.41695',
    category_id: 3,
    cover_image: 'food/food3.jpg'
  },
  {
    name: 'Havana Cafe',
    address: 'Birla High School, Hungerford Street, Mallick Bazaar, Ho Chi Minh Sarani, Kolkata, West Bengal, 700071, India',
    latitude: '22.5445663',
    longitude: '88.3544478',
    category_id: 3,
    cover_image: 'food/food4.jpg'
  },
  {
    name: 'Grillss N Chillss',
    address: 'Manoharpukur, Kolkata, West Bengal, 700033, India',
    latitude: '22.5150583',
    longitude: '88.3528332',
    category_id: 2,
    cover_image: 'food/food5.jpg'
  },
  {
    name: '6 Ballygunge Place',
    address: 'Hindustan Club, Ramani Chatterji Road, Ballygunge, Kolkata, West Bengal, 700029, India',
    latitude: '22.5192695',
    longitude: '88.3606188',
    category_id: 1,
    cover_image: 'food/food7.jpg'
  },
  {
    name: 'dada hindu',
    address: 'Anjali Bari, Sri Aurobindo Sarani, Shyam Bazar, Kolkata, West Bengal, 700005, India',
    latitude: '22.5956483',
    longitude: '88.365898',
    category_id: nil,
    cover_image: 'food/food6.jpg'
  },
  {
    name: 'Bhooter raja dilo bor',
    address: 'GN Block, Sector V, Bidhannagar, Bhangar - II, South 24 Parganas, West Bengal, 700091, India',
    latitude: '22.5688991',
    longitude: '88.4283597',
    category_id: 1,
    cover_image: 'food/food5.jpg'
  },
  {
    name: 'Dada boudi Resturant',
    address: "Devil's, Barrackpore Trunk Road, Milan Garh Colony, Sodepur, Kamarhati, Barrackpore, North 24 Parganas, West Bengal, 700114, India",
    latitude: '22.7604784',
    longitude: '88.3671125',
    category_id: 1,
    cover_image: 'food/food10.jpg'
  },
  {
    name: 'Arsalan',
    address: 'Kolkata, West Bengal, 700107, India',
    latitude: '22.519388',
    longitude: '88.3964386',
    category_id: 1,
    cover_image: 'food/food9.jpg'
  },
  {
    name: 'Lets eat',
    address: 'Kalyani City, Kalyani, Nadia, West Bengal, 741235, India',
    latitude: '22.9793009',
    longitude: '88.4322281',
    category_id: 1,
    cover_image: 'food/food8.jpg'
  }
]

resturants.each do |resturant_data|
  cover_image = open(Rails.root.join('app', 'assets', 'images', resturant_data[:cover_image]))
  resturant_data[:cover_image] = ActiveStorage::Blob.create_after_upload!(
    io: cover_image,
    filename: File.basename(cover_image),
    content_type: 'image/jpeg'
  ).signed_id
end
Resturant.transaction do
  resturants.each do |resturant_attrs|
    Resturant.create!(resturant_attrs)
  end
end

# Seed foods
foods = [
  {
    resturant_id: Resturant.find_by(name: 'Dada boudi Resturant').id,
    food_name: 'Biriyani',
    food_price: 400,
    food_image: 'food/food1.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Dada boudi Resturant').id,
    food_name: 'Momo',
    food_price: 100,
    food_image: 'food/food2.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Dada boudi Resturant').id,
    food_name: 'Chowmin',
    food_price: 200,
    food_image: 'food/food3.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Dada boudi Resturant').id,
    food_name: 'Chocolate',
    food_price: 300,
    food_image: 'food/food4.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Barbeque Nation').id,
    food_name: 'Mutton',
    food_price: 200,
    food_image: 'food/food5.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Barbeque Nation').id,
    food_name: 'Chicken',
    food_price: 300,
    food_image: 'food/food6.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Barbeque Nation').id,
    food_name: 'Pizza',
    food_price: 300,
    food_image: 'food/food7.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Bhooter raja dilo bor').id,
    food_name: 'Rice',
    food_price: 300,
    food_image: 'food/food8.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Arsalan').id,
    food_name: 'Dal makhani',
    food_price: 300,
    food_image: 'food/food9.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Arsalan').id,
    food_name: 'Paneer masala',
    food_price: 460,
    food_image: 'food/food10.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Bhooter raja dilo bor').id,
    food_name: 'Mutton thali',
    food_price: 900,
    food_image: 'food/food2.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Mainland China').id,
    food_name: 'chowmin',
    food_price: 200,
    food_image: 'food/food3.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Mainland China').id,
    food_name: 'chilli chicken',
    food_price: 300,
    food_image: 'food/food2.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Chowman').id,
    food_name: 'chicken lollipop',
    food_price: 100,
    food_image: 'food/food7.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Chowman').id,
    food_name: 'fried rice',
    food_price: 250,
    food_image: 'food/food3.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Lets eat').id,
    food_name: 'biriyani',
    food_price: 250,
    food_image: 'food/food1.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Lets eat').id,
    food_name: 'kadai chicken',
    food_price: 250,
    food_image: 'food/food4.jpg'
  },
  {
    resturant_id: Resturant.find_by(name: 'Grillss N Chillss').id,
    food_name: 'fried rice',
    food_price: 250,
    food_image: 'food/food3.jpg'
  }
]

foods.each do |food_data|
  food_image = open(Rails.root.join('app', 'assets', 'images', food_data[:food_image]))
  food_data[:food_image] = ActiveStorage::Blob.create_after_upload!(
    io: food_image,
    filename: File.basename(food_image),
    content_type: 'image/jpeg'
  ).signed_id
  Food.create!(food_data)
end

# db/seeds/reviews.rb

# Create Reviews
reviews = []

Resturant.all.each do |resturant|
  2.times do
    reviews << {
      comment: 'Great food and service!',
      approval: true,
      rating: 2,
      resturant_id: resturant.id,
      review_images: 'food/food1.jpg',
      user_id: 1
    }
  end
  2.times do
    reviews << {
      comment: 'Good resturant',
      approval: false,
      rating: 2,
      resturant_id: resturant.id,
      review_images: 'food/food2.jpg',
      user_id: 1
    }
  end
end

# Seed Reviews
reviews.each do |review|
  review_images = open(Rails.root.join('app', 'assets', 'images', review[:review_images]))
  review[:review_images] = ActiveStorage::Blob.create_after_upload!(
    io: review_images,
    filename: File.basename(review_images),
    content_type: 'image/jpeg'
  ).signed_id
  Review.create(review)
end


# rubocop:enable all
