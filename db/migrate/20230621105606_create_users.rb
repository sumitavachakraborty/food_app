# frozen_string_literal: true

class CreateUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :email
      t.string :password_digest
      t.string :uid
      t.string :provider
      t.string :login_token
      t.string :token_expire
      t.string :images
      t.boolean :admin, default: false

      t.timestamps
    end
  end
end
