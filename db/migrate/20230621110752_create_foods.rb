class CreateFoods < ActiveRecord::Migration[6.1]
  def change
    create_table :foods do |t|
      t.references :resturant, null: false, foreign_key: true
      t.string :food_name
      t.string :food_price
      t.string :food_image

      t.timestamps
    end
  end
end
