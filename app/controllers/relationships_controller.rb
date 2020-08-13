class RelationshipsController < ApplicationController
  def create
    @follow = User.find(params[:user_id]) # クリックされたフォローされるアカウントを取得
    @user = User.find(params[:user_now])
    follow = current_user.active_relationships.build(follower_id: params[:user_id])
    follow.save
    follow.create_notification_follow!(current_user, follow.follower_id)
  end

  def destroy
    @follow = User.find(params[:user_id])
    @user = User.find(params[:user_now])
    follow = current_user.active_relationships.find_by(follower_id: params[:user_id])
    follow.destroy
  end
end
