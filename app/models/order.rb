class Order < ApplicationRecord
    paginates_per 4
    belongs_to :resturant
    belongs_to :user
end
