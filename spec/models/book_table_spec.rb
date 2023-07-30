#rubocop:disable all
require 'rails_helper'

RSpec.describe BookTable, type: :model do
  describe 'validations for booking a table' do
    context 'positive scenarios' do
      it 'validates presence of book_time' do
        book_table = BookTable.new(
          book_time: Time.current,
          head_count: 4,
          user: User.new, 
          resturant: Resturant.new,
          book_date: Date.today + 6.days
        )
        expect(book_table).to be_valid
      end
    end

    context 'negative scenarios' do
      it 'validates presence of book_time' do
        book_table = BookTable.new
        expect(book_table).not_to be_valid
        expect(book_table.errors[:book_time]).to include("can't be blank")
      end

      it 'validates presence of head_count' do
        book_table = BookTable.new
        expect(book_table).not_to be_valid
        expect(book_table.errors[:head_count]).to include("can't be blank")
      end

      it 'validates presence of book_date' do
        book_table = BookTable.new
        expect(book_table).not_to be_valid
        expect(book_table.errors[:book_date]).to include("must be selected")
      end

      it 'validates book_date cannot be in the past' do
        book_table = BookTable.new(book_date: Date.yesterday)
        expect(book_table).not_to be_valid
        expect(book_table.errors[:book_date]).to include("can't be in the past")
      end
    end
  end
end



#rubocop:enable all