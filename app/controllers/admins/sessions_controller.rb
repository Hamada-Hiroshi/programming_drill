# frozen_string_literal: true

class Admins::SessionsController < Devise::SessionsController
  def new_guest
    admin = Admin.guest
    sign_in admin
    user = User.admin
    sign_in user
    redirect_to admin_root_path, notice: 'ゲスト管理者としてログインしました。'
  end
  # before_action :configure_sign_in_params, only: [:create]

  # GET /resource/sign_in
  # def new
  #   super
  # end

  # POST /resource/sign_in
  def create
    super
    user = User.admin
    sign_in user
  end

  # DELETE /resource/sign_out
  # def destroy
  #   super
  # end

  # protected

  # If you have extra params to permit, append them to the sanitizer.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
  # end
end
