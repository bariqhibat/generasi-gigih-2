FactoryBot.define do
  factory :food do
    name { 'Nasi Uduk' }
    description { 'Betawi style steamed rice cooked in coconut milk. Delicious!' }
    price { 10_000.0 }
    category {Category.first || association(:category)}  # ref: https://qiita.com/Kolosek/items/7c85337f928161e0e76e
  end
end
