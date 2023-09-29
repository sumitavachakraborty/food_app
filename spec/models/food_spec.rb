#rubocop:disable all
require 'rails_helper'

RSpec.describe Food, type: :model do
  describe 'validations' do
    it 'validates presence of food_name' do
      food = Food.new(food_name: nil)
      food.valid?
      expect(food.errors[:food_name]).to include("can't be blank")
    end

    it 'validates presence of food_price' do
      food = Food.new(food_price: nil)
      food.valid?
      expect(food.errors[:food_price]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'belongs to a restaurant' do
      association = Food.reflect_on_association(:restaurant)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end

#rubocop:enable all