#rubocop:disable all
require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'validations' do
    let(:user) { User.create(username: 'testuser', email: 'test@example.com', password: 'password') }
    let(:resturant) { Resturant.create(name: 'Test Resturant', address: '123 Test Street') }

    it 'is not valid without a rating' do
      review = Review.new(user: user, resturant: resturant, rating: nil)
      expect(review).not_to be_valid
      expect(review.errors[:rating]).to include("can't be blank")
    end

    it 'is not valid with a comment shorter than the minimum length' do
      review = Review.new(user: user, resturant: resturant, comment: 'Hi')
      expect(review).not_to be_valid
      expect(review.errors[:comment]).to include('is too short (minimum is 3 characters)')
    end

    it 'is valid with a comment within the length limit' do
      review = Review.new(user: user, resturant: resturant, comment: 'Great restaurant', rating: 4, review_images: [])
      expect(review).to be_valid
    end

    it 'is not valid with a comment longer than the maximum length' do
      long_comment = 'This is a very long comment exceeding the maximum length limit'
      review = Review.new(user: user, resturant: resturant, comment: long_comment)
      expect(review).not_to be_valid
      expect(review.errors[:comment]).to include('is too long (maximum is 45 characters)')
    end
  end
end



#rubocop:enable all