FactoryBot.define do
  factory :review_1, class: Review do
    content { Faker::Lorem.characters(number: 30) }
    rate { 1 }
    association :user
    association :app
  end

  factory :review_2, class: Review do
    content { Faker::Lorem.characters(number: 30) }
    rate { 2 }
    association :user
    association :app
  end

  factory :review_3, class: Review do
    content { Faker::Lorem.characters(number: 30) }
    rate { 3 }
    association :user
    association :app
  end

  factory :review_4, class: Review do
    content { Faker::Lorem.characters(number: 30) }
    rate { 4 }
    association :user
    association :app
  end

  factory :review_5, class: Review do
    content { Faker::Lorem.characters(number: 30) }
    rate { 5 }
    association :user
    association :app
  end

end
