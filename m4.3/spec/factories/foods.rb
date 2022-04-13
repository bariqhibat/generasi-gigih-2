FactoryBot.define do
  factory :food do
    name { Faker::Food.dish }
    description { Faker::Food.description }
    price { Faker::Number.positive }
    category {Category.first || association(:category)}  # ref: https://qiita.com/Kolosek/items/7c85337f928161e0e76e
  end
end
