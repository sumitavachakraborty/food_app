class Order < ApplicationRecord
    belongs_to :resturant
    belongs_to :user
end
