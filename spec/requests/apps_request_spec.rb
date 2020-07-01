require 'rails_helper'

RSpec.describe "Apps", type: :request do
  let(:lang) { create(:lang) }
  let(:user) { create(:user) }
  let(:test_app) { create(:app, user_id: user.id, lang_id: lang.id) }
  let(:review_2_user) { create(:user) }
  let(:review_4_user) { create(:user) }
  let!(:review_2) { create(:review_2, user_id: review_2_user.id, app_id: test_app.id) }
  let!(:review_4) { create(:review_4, user_id: review_4_user.id, app_id: test_app.id) }

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
      sign_in user
    end

    context '正常なパラメータの場合' do
      it 'リクエストが成功する' do
        post confirm_apps_path, params: { user_id: user, lang_id: lang, app: attributes_for(:app) }
        expect(response.status).to eq 200
      end
    end

    context '不正なパラメータの場合' do
      it 'リクエストが成功する' do
        post confirm_apps_path, params: { user_id: user, lang_id: lang, app: attributes_for(:app, :invalid) }
        expect(response.status).to eq 200
      end
    end
  end
end
