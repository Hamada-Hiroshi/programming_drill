require 'rails_helper'

RSpec.describe "Apps", type: :request do
  let(:test_app) { create(:app) }
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

  xdescribe 'POST confirm' do
    before do
      sign_in user
    end

    context '正常なパラメータの場合' do
      it 'リクエストが成功する' do
        pending
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
