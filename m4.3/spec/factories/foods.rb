FactoryBot.define do
  factory :food do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    price { Faker::Number.positive }
    category { Category.first || association(:category) }  # ref: https://qiita.com/Kolosek/items/7c85337f928161e0e76e
  end

  factory :invalid_food, parent: :food do
    name { nil }
    description { nil }
    price { 10_000.0 }
  end
end
