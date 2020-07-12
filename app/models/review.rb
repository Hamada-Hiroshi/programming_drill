class Review < ApplicationRecord
  belongs_to :user
  belongs_to :app
  has_many :notifications, dependent: :destroy
  validates :content, presence: true
  validates :rate, numericality: { less_than_or_equal_to: 5, greater_than_or_equal_to: 1 },
                   presence: true

  def create_notification_review!(current_user, app_user_id, review_id)
    notification = current_user.active_notifications.new(
      visited_id: app_user_id,
      review_id: review_id,
      action: "review"
    )
    notification.save
  end
end
