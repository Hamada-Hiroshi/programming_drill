class LanguagesController < ApplicationController
  def show
    @languages = Language.all
    @language = Language.find(params[:id])
    @apps = @language.apps.all.order(created_at: "DESC")
  end

  def rate_show
    @languages = Language.all
    @language = Language.find(params[:id])
    @apps = @language.apps.all #評価順にソート
  end

end
