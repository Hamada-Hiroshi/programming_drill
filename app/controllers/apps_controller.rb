class AppsController < ApplicationController
  before_action :set_app, only: [:show, :edit, :add_edit, :update, :add_update, :hint, :explanation, :hidden, :cancel]

  def set_app
    @app = App.find(params[:id])
  end

  def index
    @languages = Language.all
    @apps = App.where(status: true).order(created_at: "DESC")
  end

  def rate_index
    @languages = Language.all
    @apps = App.where(status: true) #評価順にソートする
  end

  def new
    @app = App.new
  end

  def confirm
    @app = session[:app] = current_user.apps.new(app_params)
    unless @app.valid?
      render 'new'
    end
  end

  def create
    @app = App.new(session[:app])
    if params[:back]
      render 'new'
    else
      @app.save
      flash[:success] = "新規投稿に成功しました。"
      redirect_to app_path(@app)
    end
  end

  def show
    @learning = Learning.find_by(user_id: current_user.id, app_id: @app.id)
  end

  def edit
  end

  def add_edit
  end

  def update
    if @app.update(app_params)
      flash[:success] = "投稿アプリを更新しました。"
      redirect_to app_path(@app)
    else
      render 'edit'
    end
  end

  def add_update
    if @app.update(add_app_params)
      flash[:success] = "投稿アプリを更新しました。"
      redirect_to app_path(@app)
    else
      render 'add_edit'
    end
  end

  def hint
  end

  def explanation
  end

  def hidden
  end

  def cancel
    @app.update(status: false)
    flash[:alert] = "アプリを非公開にしました。"
    redirect_to user_path(current_user)
  end

  private
  def app_params
    params.require(:app).permit(:title, :language_id, :overview, :app_url, :repo_url, :function, :target)
  end

  def add_app_params
    params.require(:app).permit(:hint, :explanation)
  end
end
