class ReviewsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    @app = App.find(params[:app_id])
    if user_signed_in?
      @learning = Learning.find_by(user_id: current_user.id, app_id: @app.id)
      @my_review = Review.find_by(user_id: current_user.id, app_id: @app.id)
    end
    @review = Review.new
    @reviews = @app.reviews.order(created_at: "DESC")
  end

  def create
    @app = App.find(params[:app_id])
    @review = current_user.reviews.new(review_params)
    @review.app_id = @app.id
    @reviews = @app.reviews.order(created_at: "DESC")
    if @review.save
      flash[:success] = "レビューを投稿しました。"

    else
      @learning = Learning.find_by(user_id: current_user.id, app_id: @app.id)
      @my_review = Review.find_by(user_id: current_user.id, app_id: @app.id)
      render 'index'
    end
  end

  private
  def review_params
    params.require(:review).permit(:rate, :content)
  end
end
