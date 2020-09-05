module NotificationsHelper
  def notification_form(notification)
    @visitor = notification.visitor
    case notification.action
    when "question" then
      @question = Question.find(notification.question_id)
      @content = @question.content
      @app = @question.app
      @content_path = app_questions_path(@app)
      tag.a(@visitor.name, href: user_path(@visitor)) + "さんがあなたのアプリケーション（" + tag.a(@app.title, href: app_path(@app)) + "）に質問を投稿しました。"
    when "reply" then
      @question = Question.find(notification.question_id)
      @content = @question.content
      @app = @question.app
      @content_path = app_questions_path(@app)
      tag.a(@visitor.name, href: user_path(@visitor)) + "さんがあなたの質問に対して回答を投稿しました。"
    when "review" then
      @review = Review.find(notification.review_id)
      @content = @review.content
      @app = @review.app
      @content_path = app_reviews_path(@app)
      tag.a(@visitor.name, href: user_path(@visitor)) + "さんがあなたのアプリケーション（" + tag.a(@app.title, href: app_path(@app)) + "）にレビューを投稿しました。"
    when "follow"
      tag.a(@visitor.name, href: user_path(@visitor)) + "さんにフォローされました。"
    end
  end

  def unchecked_notifications
    @notifications = current_user.passive_notifications.where(checked: false)
  end
end
