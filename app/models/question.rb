class Question < ApplicationRecord
  belongs_to :user
  belongs_to :app
  belongs_to :parent, class_name: "Question", optional: true
  has_many :replies, class_name: "Question", foreign_key: :parent_id, dependent: :destroy
  has_many :notifications, dependent: :destroy
  validates :content, presence: true

  def create_notification_question!(current_user, app_user_id, question_id)
    notification = current_user.active_notifications.new(
      visited_id: app_user_id,
      question_id: question_id,
      action: "question"
    )
    notification.save
  end

  def create_notification_reply!(current_user, parent_user_id, question_id)
    if current_user.id != parent_user_id
      notification = current_user.active_notifications.new(
        visited_id: parent_user_id,
        question_id: question_id,
        action: "reply"
      )
      notification.save
    end
  end
end
