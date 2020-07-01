class Admin::LangsController < ApplicationController
  before_action :authenticate_admin!
  before_action :set_lang, only: [:show, :update, :destroy]

  def set_lang
    @lang = Lang.find(params[:id])
  end

  def index
    @langs = Lang.all
    @lang = Lang.new
    @apps = App.where(status: true)
  end

  def create
    @lang = Lang.new(lang_params)
    if @lang.save
      flash[:success] = "新しい開発言語を登録しました。"
      redirect_back(fallback_location: admin_root_path)
    else
      @langs = Lang.all
      @apps = App.where(status: true)
      render 'index'
    end
  end

  def show
  end

  def update
    if @lang.update(lang_params)
      flash[:success] = "開発言語名を更新しました。"
      redirect_back(fallback_location: admin_root_path)
    else
      render 'show'
    end
  end

  def destroy
    @lang.destroy
    flash[:success] = "登録済みの開発言語を削除しました。"
    redirect_to admin_root_path
  end

  private

  def lang_params
    params.require(:lang).permit(:name)
  end
end
