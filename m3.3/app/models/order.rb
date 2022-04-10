class Order < ActiveRecord::Base
    has_one :customer
end
