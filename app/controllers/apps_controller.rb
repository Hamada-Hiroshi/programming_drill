class AppsController < ApplicationController
  before_action :authenticate_user!, only: [
    :new, :confirm, :create,
    :edit, :hint_edit, :explanation_edit, :update, :add_update, :hint, :explanation, :hidden, :cancel,
  ]
  before_action :set_app, only: [:show, :edit, :hint_edit, :explanation_edit, :update, :add_update, :hint, :explanation, :hidden, :cancel]
  before_action :set_learning, only: [:show, :hint, :explanation]
  before_action :set_langs, only: [:index, :rate_index, :popular_index, :tag, :rate_tag, :popular_tag]
  before_action :set_apps_score, only: [:index, :rate_index, :popular_index]
  before_action :set_tag_apps_score, only: [:tag, :rate_tag, :popular_tag]
  before_action :set_available_tags_to_gon, only: [:new, :confirm, :create, :edit, :update]
  before_action :ensure_correct_user, only: [:edit, :hint_edit, :explanation_edit, :update, :add_update, :hidden, :cancel]
  before_action :ensure_learning_user, only: [:hint, :explanation]

  def set_app
    @app = App.find(params[:id])
  end

  def set_learning
    if user_signed_in?
      @learning = Learning.find_by(user_id: current_user.id, app_id: @app.id)
    end
  end

  def set_langs
    @langs = Lang.all
  end

  def set_apps_score
    @apps = @q.result(distinct: true).where(status: true).includes(:user, :lang, :reviews, :taggings)
    @apps.each do |app|
      app.score = app.average_rate
    end
  end

  def set_tag_apps_score
    @apps = App.tagged_with(params[:tag_name]).where(status: true).includes(:user, :lang, :reviews, :taggings)
    @apps.each do |app|
      app.score = app.average_rate
    end
  end

  def set_available_tags_to_gon
    gon.available_tags = App.tags_on(:tags).pluck(:name)
  end



  def index
    @apps = @apps.page(params[:page]).reverse_order
  end

  def rate_index
    @apps = @apps.sort_by { |app| app.score.to_f }.reverse
    @apps = Kaminari.paginate_array(@apps).page(params[:page])
  end

  def popular_index
    @apps = @apps.sort_by { |app| app.learnings.count }.reverse
    @apps = Kaminari.paginate_array(@apps).page(params[:page])
  end

  def tag
    @apps = @apps.page(params[:page]).reverse_order
  end

  def rate_tag
    @apps = @apps.sort_by { |app| app.score.to_f }.reverse
    @apps = Kaminari.paginate_array(@apps).page(params[:page])
  end

  def popular_tag
    @apps = @apps.sort_by { |app| app.learnings.count }.reverse
    @apps = Kaminari.paginate_array(@apps).page(params[:page])
  end

  def new
    @app = App.new
  end

  def confirm
    @app = session[:app] = current_user.apps.new(app_params)
    unless @app.valid?
      gon.app_tags = @app.tag_list
      render 'new'
    end
  end

  def create
    @app = App.new(session[:app])
    if params[:back]
      gon.app_tags = @app.tag_list
      render 'new'
    else
      @app.save
      flash[:success] = "アプリケーションの新規投稿に成功しました。"
      redirect_to app_path(@app)
    end
  end

  def show
  end

  def edit
    gon.app_tags = @app.tag_list
  end

  def hint_edit
  end

  def explanation_edit
  end

  def update
    if @app.update(app_params)
      flash[:success] = "アプリケーション情報を更新しました。"
      redirect_to app_path(@app)
    else
      gon.app_tags = @app.tag_list
      render 'edit'
    end
  end

  def add_update
    if params[:app][:hint]
      @app.update(add_app_params)
      flash[:success] = "アプリケーションのヒントを更新しました。"
      redirect_to hint_app_path(@app)
    else
      @app.update(add_app_params)
      flash[:success] = "アプリケーションの解説を更新しました。"
      redirect_to explanation_app_path(@app)
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
    flash[:alert] = "アプリケーションを非公開にしました。"
    redirect_to user_path(current_user)
  end

  def ensure_correct_user
    if @app.user != current_user
      flash[:alert] = "アクセス権限がありません。"
      redirect_back(fallback_location: root_path)
    end
  end

  def ensure_learning_user
    if @app.user != current_user && !admin_signed_in? && Learning.find_by(user: current_user, app: @app).nil?
      flash[:alert] = "アクセス権限がありません。"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def app_params
    params.require(:app).permit(:title, :lang_id, :overview, :app_url, :repo_url, :function, :target, :tag_list, :hint, :explanation)
  end

  def add_app_params
    params.require(:app).permit(:hint, :explanation)
  end
end
