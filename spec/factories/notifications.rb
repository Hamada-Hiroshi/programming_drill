FactoryBot.define do
  factory :notification do
    visiter_id { 1 }
    visited_id { 1 }
    question_id { 1 }
    review_id { 1 }
    action { "MyString" }
    checked { false }
  end
end
