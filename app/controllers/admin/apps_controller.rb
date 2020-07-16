class Admin::AppsController < ApplicationController
  before_action :authenticate_admin!

  def index
    @apps = App.all.includes(:user, :lang)
  end

  def cancel
    @app = App.find(params[:id])
    @app.update(status: false)
    flash[:success] = "指定のアプリを非公開にしました。"
    redirect_back(fallback_location: admin_root_path)
  end
end
