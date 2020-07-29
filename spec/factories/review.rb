FactoryBot.define do
  factory :review_2, class: Review do
    content { Faker::Lorem.characters(number: 30) }
    rate { 2 }
    association :user
    association :app
  end

  factory :review_4, class: Review do
    content { Faker::Lorem.characters(number: 30) }
    rate { 4 }
    association :user
    association :app
  end

end
