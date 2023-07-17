# frozen_string_literal: true

# category rspec
require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'validations' do
    it 'validates presence of category_name' do
      category = Category.new(category_name: nil)
      category.valid?
      expect(category.errors[:category_name]).to include("can't be blank")
    end
  end

  describe 'associations' do
    it 'has many resturants' do
      association = Category.reflect_on_association(:resturants)
      expect(association.macro).to eq(:has_many)
    end
  end
end
