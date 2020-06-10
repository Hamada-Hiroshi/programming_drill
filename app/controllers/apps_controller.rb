class AppsController < ApplicationController
  before_action :set_app, only: [:show, :edit, :add_edit, :update, :hint, :explanation]

  def set_app
    @app = App.find(params[:id])
  end

  def index
    @languages = Language.all
    @apps = App.all.order(created_at: "DESC")
  end

  def rate_index
    @languages = Language.all
    @apps = App.all #評価順にソートする
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
      redirect_to user_path(current_user)
    end
  end

  def show
  end

  def edit
  end

  def add_edit
  end

  def update
  end

  def hint
  end

  def explanation
  end

  def hidden
  end

  def cancel
  end

  private
  def app_params
    params.require(:app).permit(:title, :language_id, :overview, :app_url, :repo_url, :function, :target)
  end
end
