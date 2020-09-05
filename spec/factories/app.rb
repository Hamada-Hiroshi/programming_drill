FactoryBot.define do
  factory :app do
    sequence(:title) { |n| "test_app_#{n}" }
    overview { Faker::Lorem.characters(number: 30) }
    app_url { Faker::Internet.url }
    repo_url { Faker::Internet.url }
    function { Faker::Lorem.characters(number: 100) }
    target { Faker::Lorem.characters(number: 20) }
    association :user
    association :lang

    trait :invalid do
      title { nil }
    end
  end
end
