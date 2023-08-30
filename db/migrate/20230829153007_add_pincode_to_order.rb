# frozen_string_literal: true

# changed orders column
class AddPincodeToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :pincode, :text
  end
end
