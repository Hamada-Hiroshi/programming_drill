FactoryBot.define do
  factory :review_2, class: Review do
    content { Faker::Lorem.characters(number: 30) }
    rate { 2 }
    user
    app
  end

  factory :review_4, class: Review do
    content { Faker::Lorem.characters(number: 30) }
    rate { 4 }
    user
    app
  end
end
