class Admin::LanguagesController < ApplicationController
  before_action :authenticate_admin!

  def index
    @languages = Language.all
    @language = Language.new
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

  def destroy
    @language = Language.find(params[:id])
    @language.destroy
    flash[:success] = "登録済みの開発言語を削除しました。"
    redirect_back(fallback_location: admin_root_path)
  end

  private

  def language_params
    params.require(:language).permit(:name)
  end
end
