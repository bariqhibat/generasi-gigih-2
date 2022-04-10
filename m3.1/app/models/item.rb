class Item < ApplicationRecord
    validates :name, presence: true, uniqueness: true
    validates :price, numericality: true
end
