class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user
  before_action :ensure_correct_user, only: [:edit, :update, :quit, :cancel]

  def set_user
    @user = User.find(params[:id])
  end

  def show
    @learnings = @user.learnings.includes({:app => :lang}, {:app => :reviews}, {:app => :taggings})
    @post_apps = @user.apps.includes(:lang, :reviews, :taggings)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      flash[:success] = "プロフィールを更新しました。"
      redirect_to user_path(@user)
    else
      render 'edit'
    end
  end

  def quit
  end

  def cancel
    @user.update(status: false)
    flash[:alert] = "アカウントを削除しました。"
    redirect_to root_path
  end

  def followings
    @users = @user.followings
  end

  def followers
    @users = @user.followers
  end

  def ensure_correct_user
    if @user != current_user
      flash[:alert] = "アクセス権限がありません。"
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :introduction, :skill)
  end
end
