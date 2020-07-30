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
      before do
        sign_in user
      end

      it 'リクエストが成功する' do
        patch user_path(user), params: { id: user, user: attributes_for(:user, :update_user) }
        expect(response.status).to eq 302
      end
      it 'ユーザネームが更新される' do
        expect {
          patch user_path(user), params: { id: user, user: attributes_for(:user, :update_user) }
        }.to change { User.find(user.id).name }.from('test_user').to('new_user_name')
      end
      it 'リダイレクトする' do
        patch user_path(user), params: { id: user, user: attributes_for(:user, :update_user) }
        expect(response).to redirect_to user_path(user)
      end
    end

    context "不正なパラメータの場合" do
      it "リクエストが成功すること" do
        patch user_path(user), params: { id: user, user: attributes_for(:user, :invalid) }
        expect(response.status).to eq 302
      end
      it "ユーザーネームが更新されない" do
        expect {
          patch user_path(user), params: { id: user, user: attributes_for(:user, :invalid) }
        }.not_to change { User.find(user.id).name }
      end
    end
  end
end
