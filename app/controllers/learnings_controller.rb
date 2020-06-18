class LearningsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_learning, only: [:show, :edit, :update]
  before_action :ensure_correct_user

  def set_learning
    @learning = Learning.find(params[:id])
  end

  def create
    @learning = current_user.learnings.new(app_id: params[:app_id])
    @learning.save
    flash[:success] = "学習を開始しました。"
    redirect_to app_learning_path(@learning.app, @learning)
  end

  def show
  end

  def update
    @learning.update(learning_params)
    flash[:success] = "学習記録を更新しました。"
    redirect_back(fallback_location: root_path)
  end

  def ensure_correct_user
    if @learning.user != current_user
      flash[:alert] = "アクセス権限がありません。"
      redirect_back(fallback_location: root_path)
    end
  end

  private
  def learning_params
    params.require(:learning).permit(:status, :memo)
  end
end
