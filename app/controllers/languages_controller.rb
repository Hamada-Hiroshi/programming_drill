class LanguagesController < ApplicationController
  def show
    @languages = Language.all
    @language = Language.find(params[:id])
    @apps = @language.apps.where(status: true).order(created_at: "DESC")
  end

  def rate_show
    @languages = Language.all
    @language = Language.find(params[:id])
    @apps = @language.apps.where(status: true) #評価順にソート
  end

end
