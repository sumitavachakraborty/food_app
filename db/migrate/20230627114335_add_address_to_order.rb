class AddAddressToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :delivery_address, :string
  end
end
