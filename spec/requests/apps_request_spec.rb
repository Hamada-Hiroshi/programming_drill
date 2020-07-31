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

  describe 'GET show' do
    before do
      get app_path(test_app)
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
      app_params = FactoryBot.attributes_for(:app)

      it 'リクエストが成功する' do
        post confirm_apps_path, params: { app: app_params }
        expect(response.status).to eq 200
      end
    end

    context '無効なパラメータの場合' do
      app_params = FactoryBot.attributes_for(:app, :invalid)

      it 'リクエストが成功する(エラー)' do
        post confirm_apps_path, params: { app: app_params }
        expect(response.status).to eq 200
      end
    end
  end

  xdescribe 'POST create' do
    before do
      sign_in test_user
    end

    context '有効なパラメータの場合' do
      app_params = FactoryBot.attributes_for(:app)

      it 'リクエストが成功する' do
        post apps_path, params: { app: app_params, id: 4 }
        expect(response.status).to eq 302
      end
      it 'アプリが追加される' do
        expect {
          post apps_path, params: { app: app_params }
        }.to change(test_user.apps, :count).by(1)
      end
    end

    context '無効なパラメータの場合' do
      app_params = FactoryBot.attributes_for(:app, :invalid)

      it 'リクエストが成功する(エラー)' do
        post apps_path, params: { app: app_params }
        expect(response.status).to eq 200
      end
      it 'アプリが追加されない' do
        expect {
          post apps_path, params: { app: app_params }
        }.to_not change(test_user.apps, :count)
      end
    end
  end
end
