# frozen_string_literal: true

# add column address
class AddAddressToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :address, :text
  end
end
