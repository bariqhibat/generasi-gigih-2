FactoryBot.define do
  factory :category do
    name { Faker::Food.ethnic_category }
  end
end
