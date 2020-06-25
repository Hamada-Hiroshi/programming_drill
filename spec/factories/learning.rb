FactoryBot.define do
  factory :learning do
    memo { Faker::Lorem.characters(number: 50) }
    user
    app
  end
end
