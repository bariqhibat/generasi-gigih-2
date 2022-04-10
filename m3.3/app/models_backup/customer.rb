class Customer < ActiveRecord::Base
    has_many :orders

    scope :created_before, ->(time) { where('created_at < ?', time) }
end
