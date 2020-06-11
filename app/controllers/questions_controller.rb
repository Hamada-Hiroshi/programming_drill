class QuestionsController < ApplicationController
  def index
    @app = App.find(params[:app_id])
    @learning = Learning.find_by(user_id: current_user.id, app_id: @app.id)
    @question = Question.new
    @questions = @app.questions.all
  end

  def create
    @app = App.find(params[:app_id])
    @question = current_user.questions.new(question_params)
    @question.app_id = @app.id
    if @question.save
      flash[:success] = "質問を投稿しました。"
      redirect_to app_questions_path(@app)
    else
      @learning = Learning.find_by(user_id: current_user.id, app_id: @app.id)
      @questions = @app.questions.all
      render 'index'
    end
  end

  private
  def question_params
    params.require(:question).permit(:content)
  end
end
