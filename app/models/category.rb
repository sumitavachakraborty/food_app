class Category < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    has_many :resturants
    validates :category_name, presence: true
    def self.index_data
      self.__elasticsearch__.create_index! force: true
      self.__elasticsearch__.import
    end
    settings do
      mappings dynamic: false do
        indexes :category_name, type: :text
        indexes :id, type: :keyword
      end
    end
    def as_indexed_json(options = {}){
        category_name: category_name,
        id: id
    }
    end
    
    def self.search_category(query)
        search_results = __elasticsearch__.search(
          query: {
            match: {
              category_name: {
                query: query,
                operator: "and"
              }
            }
          }
        )

        
        category_ids = search_results.map { |result| result['_id'] }
        Resturant.where(category_id: category_ids)
    end
    index_data
end
