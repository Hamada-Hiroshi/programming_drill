FactoryBot.define do
  factory :user do
    name { 'test_user_a' }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }

    trait :invalid do
      name { nil }
    end
  end

  factory :update_user, class: User do
    name { 'test_user_b' }
    email { Faker::Internet.email }
    password { 'password' }
    password_confirmation { 'password' }

    trait :invalid do
      name { nil }
    end
  end

end
