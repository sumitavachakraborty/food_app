#rubocop:disable all
require 'rails_helper'

RSpec.describe BookTable, type: :model do
  describe 'validations' do
    it 'validates presence of book_time' do
      book_table = BookTable.new(book_time: nil)
      book_table.valid?
      expect(book_table.errors[:book_time]).to include("can't be blank")
    end

    it 'validates presence of head_count' do
      book_table = BookTable.new(head_count: nil)
      book_table.valid?
      expect(book_table.errors[:head_count]).to include("can't be blank")
    end

    it 'validates book_date must be selected' do
      book_table = BookTable.new(book_date: nil)
      book_table.valid?
      expect(book_table.errors[:book_date]).to include('must be selected')
    end

    it 'validates book_date cannot be in the past' do
      book_table = BookTable.new(book_date: Date.yesterday)
      book_table.valid?
      expect(book_table.errors[:book_date]).to include("can't be in the past")
    end
  end

  describe 'associations' do
    it 'belongs to user' do
      association = BookTable.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it 'belongs to resturant' do
      association = BookTable.reflect_on_association(:resturant)
      expect(association.macro).to eq(:belongs_to)
    end
  end
end


#rubocop:enable all