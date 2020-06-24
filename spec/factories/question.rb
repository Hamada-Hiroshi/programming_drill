FactoryBot.define do
  factory :question do
    content { Faker::Lorem.characters(number:30) }
    user
    app
  end
end