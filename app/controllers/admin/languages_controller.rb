class Admin::LanguagesController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_language, only: [:show, :update, :destroy]

  def set_language
    @language = Language.find(params[:id])
  end

  def index
    @languages = Language.all
    @language = Language.new
    @apps = App.where(status: true)
  end

  def create
    @language = Language.new(language_params)
    if @language.save
      flash[:success] = "新しい開発言語を登録しました。"
      redirect_back(fallback_location: admin_root_path)
    else
      @languages = Language.all
      render 'index'
    end
  end

  def show
  end

  def update
    if @language.update(language_params)
      flash[:success] = "開発言語名を更新しました。"
      redirect_back(fallback_location: admin_root_path)
    else
      render 'show'
    end
  end

  def destroy
    @language.destroy
    flash[:success] = "登録済みの開発言語を削除しました。"
    redirect_to admin_root_path
  end

  private

  def language_params
    params.require(:language).permit(:name)
  end
end
