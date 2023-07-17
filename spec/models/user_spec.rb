#rubocop:disable all
require 'rails_helper'

# spec/models/user_spec.rb

RSpec.describe User, type: :model do
  describe 'validations' do
    it 'is valid with valid attributes' do
      user = User.new(
        username: 'sumitava.chak',
        email: 'sumitava@example.com',
        city: 'kolkata',
        password: 'password'
      )
      expect(user).to be_valid
    end

    it 'is not valid without a username' do
      user = User.new(
        email: 'sumitava@example.com',
        city: 'kolkata'
      )
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include("can't be blank")
    end

    it 'is not valid with a short username' do
      user = User.new(
        username: 'sc',
        email: 'sumitava@example.com',
        city: 'kolkata'
      )
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include('is too short (minimum is 3 characters)')
    end

    it 'is not valid with a long username' do
      user = User.new(
        username: 'sumitava' * 5,
        email: 'sumitava@example.com',
        city: 'kolkata'
      )
      expect(user).not_to be_valid
      expect(user.errors[:username]).to include('is too long (maximum is 25 characters)')
    end

    it 'is not valid without an email' do
      user = User.new(
        username: 'sumi.tava',
        city: 'kolkata'
      )
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include("can't be blank")
    end

    it 'is not valid with an invalid email format' do
      user = User.new(
        username: 'sumi.tava',
        email: 'invalid_email',
        city: 'kolkata'
      )
      expect(user).not_to be_valid
      expect(user.errors[:email]).to include('is invalid')
    end

    it 'is not valid without a city' do
      user = User.new(
        username: 'sumi.tava',
        email: 'sumi.tava@example.com'
      )
      expect(user).not_to be_valid
      expect(user.errors[:city]).to include("can't be blank")
    end
  end
end

#rubocop:enable all