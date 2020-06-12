class ReviewsController < ApplicationController
  def index
    @app = App.find(params[:app_id])
    @learning = Learning.find_by(user_id: current_user.id, app_id: @app.id)
    @my_review = Review.find_by(user_id: current_user.id, app_id: @app.id)
    @review = Review.new
    @reviews = @app.reviews.order(created_at: "DESC")
  end

  def create
    @app = App.find(params[:app_id])
    @review = current_user.reviews.new(review_params)
    @review.app_id = @app.id
    if @review.save
      flash[:success] = "レビューを投稿しました。"
      redirect_to app_reviews_path(@app)
    else
      @learning = Learning.find_by(user_id: current_user.id, app_id: @app.id)
      @my_review = Review.find_by(user_id: current_user.id, app_id: @app.id)
      @reviews = @app.reviews.order(created_at: "DESC")
      render 'index'
    end
  end

  private
  def review_params
    params.require(:review).permit(:rate, :content)
  end
end
