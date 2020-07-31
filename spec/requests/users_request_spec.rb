require 'rails_helper'

RSpec.describe "Users", type: :request do
  let!(:user) { create(:user) }

  describe 'GET show' do
    context 'ログインしている場合' do
      before do
        sign_in user
        get user_path(user)
      end

      it 'リクエストが成功する' do
        expect(response.status).to eq 200
      end
    end

    context 'ログインしていない場合' do
      before do
        get user_path(user)
      end

      it 'リクエストが失敗する' do
        expect(response.status).to eq 302
      end
      it 'ログインページにリダイレクトする' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH update' do
    context '正常なパラメータの場合' do
      user_params = FactoryBot.attributes_for(:user, name: "new_user_name")
      before do
        sign_in user
      end

      it 'リクエストが成功(リダイレクト)する' do
        patch user_path(user), params: { user: user_params }
        expect(response.status).to eq 302
      end
      it 'ユーザネームが更新される' do
        patch user_path(user), params: { user: user_params }
        expect(user.reload.name).to eq "new_user_name"
      end
      it 'マイページへリダイレクトする' do
        patch user_path(user), params: { user: user_params }
        expect(response).to redirect_to user_path(user)
      end
    end

    context "不正なパラメータの場合" do
      user_params = FactoryBot.attributes_for(:user, :invalid)
      before do
        sign_in user
      end

      it "リクエストが成功する(リダイレクトはしない)" do
        patch user_path(user), params: { user: user_params }
        expect(response.status).to eq 200
      end
      it "ユーザーネームが更新されない" do
        patch user_path(user), params: { user: user_params }
        expect(user.reload.name).to eq "test_user"
      end
    end
  end
end
