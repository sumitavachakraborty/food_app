class Resturant < ApplicationRecord
    include Elasticsearch::Model
    include Elasticsearch::Model::Callbacks
    def self.index_data
      self.__elasticsearch__.create_index! force: true
      self.__elasticsearch__.import
    end
    
    settings do
      mappings dynamic: false do
        indexes :name, type: :text
        indexes :city, type: :text
        indexes :id, type: :keyword
      end
    end
    
    def as_indexed_json(options = {}){
        name: name,
        city: city,
        id: id
      }
    end
    
    def self.search_res(query)
        __elasticsearch__.search(
          {
            query: {
              bool: {
                should: [
                  {
                    wildcard: {
                      name: {
                        value: "*#{query}*",
                        boost: 1.0
                      }
                    }
                  },
                  {
                    wildcard: {
                      city: {
                        value: "*#{query}*",
                        boost: 0.5
                      }
                    }
                  }
                ]
              }
            }
          }
        )
      end
      
    index_data

    # before_save { self.name = name.downcase}
    has_many_attached :cover_image
    has_many :foods, dependent: :destroy
    has_many :orders, dependent: :destroy
    has_many :reviews, dependent: :destroy
    has_one :category
    has_many :book_tables, dependent: :destroy

    validates :name, presence: true, length: {minimum: 3, maximum: 45}
    validates :latitude, presence: true
    validates :longitude, presence: true
end
