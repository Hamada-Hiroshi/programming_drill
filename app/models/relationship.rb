class Relationship < ApplicationRecord
  default_scope -> { order(created_at: :desc) }
  belongs_to :following, class_name: "User"
  belongs_to :follower, class_name: "User"
end
