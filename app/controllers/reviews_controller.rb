class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    @app = App.find(params[:app_id])
    if user_signed_in?
      @learning = Learning.find_by(user_id: current_user.id, app_id: @app.id)
      @my_review = Review.find_by(user_id: current_user.id, app_id: @app.id)
    end
    @review = Review.new
    @reviews = @app.reviews.order(created_at: "DESC").includes(:user)
  end

  def create
    @app = App.find(params[:app_id])
    @learning = Learning.find_by(user_id: current_user.id, app_id: @app.id)
    @my_review = Review.find_by(user_id: current_user.id, app_id: @app.id)
    @review = current_user.reviews.new(review_params)
    @review.app_id = @app.id
    if params[:auto_rate]
      score = Language.get_data(review_params[:content])
      @review.rate = (score + 1.5) * 2
    end
    @reviews = @app.reviews.order(created_at: "DESC")
    if @review.save
      # レビューを投稿した後にもう一度@my_reviewを取得し、form部分の条件分岐に利用する。
      @my_review = Review.find_by(user_id: current_user.id, app_id: @app.id)
      flash.now[:success] = "レビューを投稿しました。"
      @review.create_notification_review!(current_user, @app.user_id, @review.id)
    end
    respond_to do |format|
      format.js
    end
  end

  private

  def review_params
    params.require(:review).permit(:rate, :content)
  end
end
