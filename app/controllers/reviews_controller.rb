class ReviewsController < ApplicationController
  def index
    @app = App.find(params[:app_id])
    @learning = Learning.find_by(user_id: current_user.id, app_id: @app.id)
    @review = Review.new
  end
end
