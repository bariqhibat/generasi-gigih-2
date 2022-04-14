FactoryBot.define do
  factory :food do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    price { Faker::Number.positive }
  end

  factory :invalid_food, parent: :food do
    name {nil}
    description {nil}
    price {10000.0}
  end
end