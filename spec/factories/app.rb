FactoryBot.define do
  factory :app do
    title { Faker::Lorem.characters(number: 10) }
    overview { Faker::Lorem.characters(number: 30) }
    app_url { Faker::Internet.url }
    repo_url { Faker::Internet.url }
    function { Faker::Lorem.characters(number: 100) }
    target { Faker::Lorem.characters(number: 20) }
    user
    lang

    trait :invalid do
      title { nil }
    end
  end
end
