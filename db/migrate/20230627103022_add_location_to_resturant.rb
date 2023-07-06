class AddLocationToResturant < ActiveRecord::Migration[6.1]
  def change
    add_column :resturants, :city , :string
    add_column :resturants, :latitude , :string
    add_column :resturants, :longitude , :string
  end
end
