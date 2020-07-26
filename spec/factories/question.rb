FactoryBot.define do
  factory :question do
    content { Faker::Lorem.characters(number: 30) }
    association :user
    association :app
  end
end
