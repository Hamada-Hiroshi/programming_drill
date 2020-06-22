FactoryBot.define do
  factory :review do
    content { Faker::Lorem.characters(number:30) }
    rate { 3.5 }
    user
    app
  end
end