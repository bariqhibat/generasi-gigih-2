class Category < ApplicationRecord
    # rails generate scaffold_controller Category name
    has_many :food
    validates :name, presence: true, uniqueness: true
end
