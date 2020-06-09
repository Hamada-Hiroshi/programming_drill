class UsersController < ApplicationController
  before_action :set_user

  def set_user
    @user = User.find(params[:id])
  end

  def show
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

  private
  def user_params
    params.require(:user).permit(:name, :email, :profile_image, :introduction, :skill)
  end
end
