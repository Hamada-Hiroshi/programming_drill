FactoryBot.define do
  factory :stock do
    association :user
    association :app
  end
end
