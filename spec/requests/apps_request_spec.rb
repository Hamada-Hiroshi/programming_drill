require 'rails_helper'

RSpec.describe "Apps", type: :request do
  let(:test_user) { create(:user) }
  let(:test_app) { create(:app, user: test_user) }
  let!(:review_2) { create(:review_2, app: test_app) }
  let!(:review_4) { create(:review_4, app: test_app) }

  describe 'GET index' do
    before do
      get root_path
    end

    it 'リクエストが成功する' do
      expect(response.status).to eq 200
    end
    it '平均評価が表示される' do
      expect(response.body).to include('3.0')
    end
  end

  describe 'POST confirm' do
    before do
      sign_in test_user
    end

    context '有効なパラメータの場合' do
      it 'リクエストが成功する' do
        post confirm_apps_path, params: { app: attributes_for(:app) }
        expect(response.status).to eq 200
      end
    end

    context '無効なパラメータの場合' do
      it 'エラーメッセージが表示される' do
        post confirm_apps_path, params: { app: attributes_for(:app, :invalid) }
        expect(response.body).to include "正しく入力されていない項目があります。"
      end
    end
  end
end
