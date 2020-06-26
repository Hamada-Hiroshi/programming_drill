class QuestionsController < ApplicationController
  before_action :authenticate_user!, only: [:create]

  def index
    @app = App.find(params[:app_id])
    @learning = Learning.find_by(user_id: current_user.id, app_id: @app.id)
    @question = Question.new
    @questions = @app.questions.where(parent_id: nil).order(created_at: "DESC")
  end

  def create
    @app = App.find(params[:app_id])
    @question = current_user.questions.new(question_params)
    @question.app_id = @app.id
    @questions = @app.questions.where(parent_id: nil).order(created_at: "DESC")
    if @question.save
      if @question.parent_id.nil?
        flash.now[:success] = "質問を投稿しました。"
      else
        flash.now[:success] = "質問への回答を投稿しました。"
      end
      # 新しい質問投稿フォームを表示するためにインスタンスメソッドを空にする。
      @question = Question.new
    end
  end

  private

  def question_params
    params.require(:question).permit(:content, :parent_id)
  end
end
