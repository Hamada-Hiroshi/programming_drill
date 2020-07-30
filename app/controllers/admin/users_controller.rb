class Admin::UsersController < ApplicationController
  before_action :authenticate_admin!

  def index
    @user_q = User.ransack(params[:q])
    @users = @user_q.result(distinct: true).page(params[:page]).per(10)
  end

  def cancel
    @user = User.find(params[:id])
    @user.update(status: false)
    flash[:success] = "指定のユーザーを退会させました。"
    redirect_back(fallback_location: admin_root_path)
  end
end
