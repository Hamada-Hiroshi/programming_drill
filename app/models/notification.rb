class Notification < ApplicationRecord
  belongs_to :question, optional: true
  belongs_to :review, optional: true
  belongs_to :visitor, class_name: "User"
  belongs_to :visited, class_name: "User"
end
