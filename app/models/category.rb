# frozen_string_literal: true

# Category Model
class Category < ApplicationRecord
  has_many :resturants
  validates :category_name, presence: true
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  def self.index_data
    __elasticsearch__.create_index! force: true
    __elasticsearch__.import
  end
  settings do
    mappings dynamic: false do
      indexes :category_name, type: :text
      indexes :id, type: :keyword
    end
  end
  def as_indexed_json(_options = {})
    {
      category_name:,
      id:
    }
  end

  def self.search_category(query)
    search_results = __elasticsearch__.search(
      query: {
        match: {
          category_name: { query:, operator: 'and' }
        }
      }
    )

    category_ids = search_results.map { |result| result['_id'] }
    Resturant.where(category_id: category_ids)
  end
end
