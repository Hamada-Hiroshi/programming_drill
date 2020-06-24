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
        expect(response.status).not_to eq 200
      end
    end
  end

  describe 'PATCH update' do
    context '正常なパラメータの場合' do
      before do
        sign_in user
      end
      it 'リクエストが成功する' do
        patch user_path(user), params: { id: user, user: attributes_for(:update_user) }
        expect(response.status).to eq 302
      end
      it 'ユーザネームが更新される' do
        expect do
          patch user_path(user), params: { id: user, user: attributes_for(:update_user) }
        end.to change { User.find(user.id).name }.from('test_user_a').to('test_user_b')
      end
      it 'リダイレクトする' do
        patch user_path(user), params: { id: user, user: attributes_for(:update_user) }
        expect(response).to redirect_to user_path(user)
      end
    end

    context "不正なパラメータの場合" do
      it "リクエストが成功すること" do
        patch user_path(user), params: { id: user, user: attributes_for(:user, :invalid) }
        expect(response.status).to eq 302
      end
      it "ユーザーネームが更新されない" do
        expect do
          patch user_path(user), params: { id: user, user: attributes_for(:user, :invalid) }
        end.not_to change { User.find(user.id).name }
      end
    end
  end

end

