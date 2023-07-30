# frozen_string_literal: true

# Resturant Model
class Resturant < ApplicationRecord
  paginates_per 3
  has_one :category
  has_many_attached :cover_image
  has_many :foods, dependent: :destroy
  has_many :orders, dependent: :destroy
  has_many :reviews, dependent: :destroy
  has_many :book_tables, dependent: :destroy

  validates :name, presence: true, length: { minimum: 3, maximum: 45 }
  validates :latitude, presence: true
  validates :longitude, presence: true
  validate :validate_image_format

  def validate_image_format
    if cover_image.attached?
      cover_image.each do |image|
        errors.add(:cover_image, 'must be a JPEG or PNG image') unless image.content_type.in?(%w[image/jpeg image/png])
      end
    else
      errors.add(:cover_image, 'must be present')
    end
  end
  include Elasticsearch::Model
  include Elasticsearch::Model::Callbacks

  include ResturantsHelper

  def self.index_data
    __elasticsearch__.create_index! force: true
    __elasticsearch__.import
  end

  settings do
    mappings dynamic: false do
      indexes :name, type: :text
      indexes :city, type: :text
      indexes :id, type: :keyword
    end
  end

  def as_indexed_json(_options = {})
    {
      name:,
      city:,
      id:
    }
  end

  def self.search_res(query)
    __elasticsearch__.search(
      query: {
        bool: {
          should: [
            { match_phrase: { name: query } },
            { wildcard: { name: { value: "*#{query}*" } } }
          ]
        }
      }
    )
  end
end
