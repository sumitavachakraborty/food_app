#rubocop: disable all
require 'rails_helper'

RSpec.describe Restaurant, type: :model do
  describe 'associations' do
    it 'should belong to a category' do
      association = Restaurant.reflect_on_association(:category)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'should have many foods' do
      association = Restaurant.reflect_on_association(:foods)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'should have many orders' do
      association = Restaurant.reflect_on_association(:orders)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'should have many reviews' do
      association = Restaurant.reflect_on_association(:reviews)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end

    it 'should have many book_tables' do
      association = Restaurant.reflect_on_association(:book_tables)
      expect(association.macro).to eq(:has_many)
      expect(association.options[:dependent]).to eq(:destroy)
    end
  end

  describe 'validations' do
    context 'positive scenarios' do
      it 'should be valid with a name, latitude, longitude, and cover_image' do
        restaurant = build(:restaurant, name: 'ABC Restaurant', latitude: 40.7128, longitude: -74.006)
        restaurant.cover_image.attach(io: File.open(Rails.root.join('spec', 'fixtures', 'food2.jpg')),
                                     filename: 'food2.jpg', content_type: 'image/jpg')

        expect(restaurant).to be_valid
      end
    end

    context 'negative scenarios' do
      it 'should be invalid without a name' do
        restaurant = Restaurant.new(name: nil, latitude: '40.7128', longitude: '-74.006')
        expect(restaurant).not_to be_valid
        expect(restaurant.errors[:name]).to include("can't be blank")
      end

      it 'should be invalid without a latitude' do
        restaurant = Restaurant.new(name: 'ABC Restaurant', latitude: nil, longitude: '-74.006')
        expect(restaurant).not_to be_valid
        expect(restaurant.errors[:latitude]).to include("can't be blank")
      end

      it 'should be invalid without a longitude' do
        restaurant = Restaurant.new(name: 'ABC Restaurant', latitude: '40.7128', longitude: nil)
        expect(restaurant).not_to be_valid
        expect(restaurant.errors[:longitude]).to include("can't be blank")
      end
    end
  end
end

# rubocop:enable all
