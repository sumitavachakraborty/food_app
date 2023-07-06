class CreateBookTables < ActiveRecord::Migration[6.1]
  def change
    create_table :book_tables do |t|
      t.references :resturant, null: false, foreign_key: true
      t.datetime :book_date
      t.datetime :book_time
      t.integer :head_count
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
