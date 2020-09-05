FactoryBot.define do
  factory :user, aliases: [:following, :follower, :visitor, :visited] do
    name { 'test_user' }
    email { Faker::Internet.unique.email }
    password { 'password' }
    password_confirmation { 'password' }

    trait :invalid do
      name { nil }
    end
  end

end
