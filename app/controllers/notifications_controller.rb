class NotificationsController < ApplicationController
  def index
    @notifications = current_user.passive_notifications.includes(:visitor)
    @notifications.where(checked: false).each do |notification|
      notification.update(checked: true)
    end
  end

  def destroy_all
    @notifications = current_user.passive_notifications.destroy_all
    redirect_to user_notifications_path(current_user)
  end
end
