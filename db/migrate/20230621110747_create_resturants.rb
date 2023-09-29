# rubocop:disable all
# frozen_string_literal: true

class CreateResturants < ActiveRecord::Migration[6.1]
  def change
    create_table :restaurants do |t|
      t.string :name
      t.text :address
      t.string :cover_image
      t.timestamps
    end
  end
end
# rubocop:enable all