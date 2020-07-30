FactoryBot.define do
  factory :question, aliases: [:parent] do
    content { Faker::Lorem.characters(number: 30) }
    association :user
    association :app
  end

  trait :reply do
    association :parent
  end
end
