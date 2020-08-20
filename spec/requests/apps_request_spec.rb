require 'rails_helper'

RSpec.describe "Apps", type: :request do
  let(:test_user) { create(:user) }
  let(:test_app) { create(:app, user: test_user) }
  let(:other_user) { create(:user) }

  describe 'GET index' do
    it 'リクエストが成功する' do
      get root_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET rate_index' do
    it 'リクエストが成功する' do
      get rate_index_apps_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET popular_index' do
    it 'リクエストが成功する' do
      get popular_index_apps_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET tag' do
    it 'リクエストが成功する' do
      get tag_apps_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET rate_tag' do
    it 'リクエストが成功する' do
      get rate_tag_apps_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET popular_tag' do
    it 'リクエストが成功する' do
      get popular_tag_apps_path
      expect(response.status).to eq 200
    end
  end

  describe 'GET new' do
    context 'ログインしている場合' do
      before do
        sign_in test_user
        get new_app_path
      end

      it 'リクエストが成功する' do
        expect(response.status).to eq 200
      end
    end

    context 'ログインしていない場合' do
      before do
        get new_app_path
      end

      it 'リクエストが失敗する' do
        expect(response.status).to eq 302
      end
      it 'ログインページにリダイレクトする' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'POST confirm' do
    before do
      sign_in test_user
    end

    context '有効なパラメータの場合' do
      let(:app_params) { FactoryBot.attributes_for(:app) }

      it 'リクエストが成功する' do
        post confirm_apps_path, params: { app: app_params }
        expect(response.status).to eq 200
      end
    end

    context '無効なパラメータの場合' do
      let(:app_params) { FactoryBot.attributes_for(:app, :invalid) }

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
  
    it 'リクエストが成功する' do
      post apps_path, session: { app: FactoryBot.attributes_for(:app, user: test_user) }
      expect(response.status).to eq 302
    end
    it 'アプリが追加される' do
      expect {
        post apps_path, session: { app: FactoryBot.attributes_for(:app, user: test_user) }
      }.to change(test_user.apps, :count).by(1)
    end
  end

  describe 'GET show' do
    it 'リクエストが成功する' do
      get app_path(test_app)
      expect(response.status).to eq 200
    end
  end

  describe 'GET edit' do
    context 'アプリ投稿者の場合' do
      before do
        sign_in test_user
        get edit_app_path(test_app)
      end

      it 'リクエストが成功する' do
        expect(response.status).to eq 200
      end
    end

    context '投稿者以外のユーザの場合' do
      before do
        sign_in other_user
        get edit_app_path(test_app)
      end

      it 'リクエストが失敗する' do
        expect(response.status).to eq 302
      end
      it 'トップページにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end

    context 'ログインしていない場合' do
      before do
        get edit_app_path(test_app)
      end

      it 'リクエストが失敗する' do
        expect(response.status).to eq 302
      end
      it 'ログインページにリダイレクトする' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET hint_edit' do
    context 'アプリ投稿者の場合' do
      before do
        sign_in test_user
        get hint_edit_app_path(test_app)
      end

      it 'リクエストが成功する' do
        expect(response.status).to eq 200
      end
    end

    context '投稿者以外のユーザの場合' do
      before do
        sign_in other_user
        get hint_edit_app_path(test_app)
      end

      it 'リクエストが失敗する' do
        expect(response.status).to eq 302
      end
      it 'トップページにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end

    context 'ログインしていない場合' do
      before do
        get hint_edit_app_path(test_app)
      end

      it 'リクエストが失敗する' do
        expect(response.status).to eq 302
      end
      it 'ログインページにリダイレクトする' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET explanation_edit' do
    context 'アプリ投稿者の場合' do
      before do
        sign_in test_user
        get explanation_edit_app_path(test_app)
      end

      it 'リクエストが成功する' do
        expect(response.status).to eq 200
      end
    end

    context '投稿者以外のユーザの場合' do
      before do
        sign_in other_user
        get explanation_edit_app_path(test_app)
      end

      it 'リクエストが失敗する' do
        expect(response.status).to eq 302
      end
      it 'トップページにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end

    context 'ログインしていない場合' do
      before do
        get explanation_edit_app_path(test_app)
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
      let(:app_params) { { title: "new_app_title" } }
      before do
        sign_in test_user
      end

      it 'リクエストが成功(リダイレクト)する' do
        patch app_path(test_app), params: { app: app_params }
        expect(response.status).to eq 302
      end
      it 'タイトルが更新される' do
        patch app_path(test_app), params: { app: app_params }
        expect(test_app.reload.title).to eq "new_app_title"
      end
      it 'アプリ詳細ページへリダイレクトする' do
        patch app_path(test_app), params: { app: app_params }
        expect(response).to redirect_to app_path(test_app)
      end
    end

    context "不正なパラメータの場合" do
      let(:app_params) { { title: nil } }
      before do
        sign_in test_user
      end

      it "リクエストが成功する(リダイレクトはしない)" do
        patch app_path(test_app), params: { app: app_params }
        expect(response.status).to eq 200
      end
      it "タイトルが更新されない" do
        patch app_path(test_app), params: { app: app_params }
        expect(test_app.reload.title).to include "test_app_"
      end
    end
  end

  describe 'PATCH add_update' do
    context 'ヒントを更新した場合' do
      let(:hint_params) { { hint: "test_app_hint" } }
      before do
        sign_in test_user
      end

      it 'リクエストが成功(リダイレクト)する' do
        patch add_update_app_path(test_app), params: { app: hint_params }
        expect(response.status).to eq 302
      end
      it 'ヒントが更新される' do
        patch add_update_app_path(test_app), params: { app: hint_params }
        expect(test_app.reload.hint).to eq "test_app_hint"
      end
      it 'ヒントページへリダイレクトする' do
        patch add_update_app_path(test_app), params: { app: hint_params }
        expect(response).to redirect_to hint_app_path(test_app)
      end
    end

    context "解説を更新した場合" do
      let(:explanation_params) { { explanation: "test_app_explanation" } }
      before do
        sign_in test_user
      end

      it 'リクエストが成功(リダイレクト)する' do
        patch add_update_app_path(test_app), params: { app: explanation_params }
        expect(response.status).to eq 302
      end
      it '解説が更新される' do
        patch add_update_app_path(test_app), params: { app: explanation_params }
        expect(test_app.reload.explanation).to eq "test_app_explanation"
      end
      it '解説ページへリダイレクトする' do
        patch add_update_app_path(test_app), params: { app: explanation_params }
        expect(response).to redirect_to explanation_app_path(test_app)
      end
    end
  end

  describe 'GET hint' do
    context 'アプリ投稿者の場合' do
      before do
        sign_in test_user
        get hint_app_path(test_app)
      end

      it 'リクエストが成功する' do
        expect(response.status).to eq 200
      end
    end

    context 'アプリ学習者の場合' do
      let!(:learning) { create(:learning, user: other_user, app: test_app) }
      before do
        sign_in other_user
        get hint_app_path(test_app)
      end

      it 'リクエストが成功する' do
        expect(response.status).to eq 200
      end
    end

    context '学習者ではないユーザの場合' do
      before do
        sign_in other_user
        get hint_app_path(test_app)
      end

      it 'リクエストが失敗する' do
        expect(response.status).to eq 302
      end
      it 'リダイレクトバックする' do
        expect(response).to redirect_to root_path
      end
    end

    context 'ログインしていない場合' do
      before do
        get hint_app_path(test_app)
      end

      it 'リクエストが失敗する' do
        expect(response.status).to eq 302
      end
      it 'リダイレクトバックする' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET explanation' do
    context 'アプリ投稿者の場合' do
      before do
        sign_in test_user
        get explanation_app_path(test_app)
      end

      it 'リクエストが成功する' do
        expect(response.status).to eq 200
      end
    end

    context 'アプリ学習者の場合' do
      let!(:learning) { create(:learning, user: other_user, app: test_app) }
      before do
        sign_in other_user
        get explanation_app_path(test_app)
      end

      it 'リクエストが成功する' do
        expect(response.status).to eq 200
      end
    end

    context '学習者ではないユーザの場合' do
      before do
        sign_in other_user
        get explanation_app_path(test_app)
      end

      it 'リクエストが失敗する' do
        expect(response.status).to eq 302
      end
      it 'リダイレクトバックする' do
        expect(response).to redirect_to root_path
      end
    end

    context 'ログインしていない場合' do
      before do
        get explanation_app_path(test_app)
      end

      it 'リクエストが失敗する' do
        expect(response.status).to eq 302
      end
      it 'リダイレクトバックする' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'GET hidden' do
    context 'アプリ投稿者の場合' do
      before do
        sign_in test_user
        get hidden_app_path(test_app)
      end

      it 'リクエストが成功する' do
        expect(response.status).to eq 200
      end
    end

    context '投稿者以外のユーザの場合' do
      before do
        sign_in other_user
        get hidden_app_path(test_app)
      end

      it 'リクエストが失敗する' do
        expect(response.status).to eq 302
      end
      it 'トップページにリダイレクトする' do
        expect(response).to redirect_to root_path
      end
    end

    context 'ログインしていない場合' do
      before do
        get hidden_app_path(test_app)
      end

      it 'リクエストが失敗する' do
        expect(response.status).to eq 302
      end
      it 'ログインページにリダイレクトする' do
        expect(response).to redirect_to new_user_session_path
      end
    end
  end

  describe 'PATCH cancel' do
    let(:app_params) { { status: false } }
    before do
      sign_in test_user
    end

    it 'リクエストが成功(リダイレクト)する' do
      patch cancel_app_path(test_app), params: { app: app_params }
      expect(response.status).to eq 302
    end
    it 'ステータスが更新される' do
      patch cancel_app_path(test_app), params: { app: app_params }
      expect(test_app.reload.status).to eq false
    end
    it 'マイページへリダイレクトする' do
      patch cancel_app_path(test_app), params: { app: app_params }
      expect(response).to redirect_to user_path(test_user)
    end
  end

end
