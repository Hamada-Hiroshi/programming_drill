class HomeController < ApplicationController
  def top
    @apps = App.limit(3).order(created_at: "DESC").includes(:user, :lang)
    @langs = Lang.all
  end

  def about
  end
end
