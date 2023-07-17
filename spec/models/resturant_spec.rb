#rubocop:disable all
require 'rails_helper'

RSpec.describe Resturant, type: :model do
  describe 'validations' do
    it 'validates presence of name' do
      resturant = Resturant.new(name: nil)
      resturant.valid?
      expect(resturant.errors[:name]).to include("can't be blank")
    end

    it 'validates length of name' do
      resturant = Resturant.new(name: 'A')
      resturant.valid?
      expect(resturant.errors[:name]).to include('is too short (minimum is 3 characters)')

      resturant.name = 'A' * 46
      resturant.valid?
      expect(resturant.errors[:name]).to include('is too long (maximum is 45 characters)')

      resturant.name = 'Valid Name'
      resturant.valid?
      expect(resturant.errors[:name]).to be_empty
    end

    it 'validates presence of latitude' do
      resturant = Resturant.new(latitude: nil)
      resturant.valid?
      expect(resturant.errors[:latitude]).to include("can't be blank")
    end

    it 'validates presence of longitude' do
      resturant = Resturant.new(longitude: nil)
      resturant.valid?
      expect(resturant.errors[:longitude]).to include("can't be blank")
    end
  end
end


#rubocop:enable all
