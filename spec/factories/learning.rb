FactoryBot.define do
  factory :learning do
    memo { Faker::Lorem.characters(number: 50) }
    association :user
    association :app
  end
end
