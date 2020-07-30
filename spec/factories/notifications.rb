FactoryBot.define do
  factory :follow_notice, class: Notification do
    association :visitor
    association :visited
    action { "follow" }
    checked { false }
  end

  trait :question_notice do
    association :question
    action { "question" }
  end

  trait :reply_notice do
    association :question
    action { "reply" }
  end

  trait :review_notice do
    association :review
    action { "review" }
  end
end
