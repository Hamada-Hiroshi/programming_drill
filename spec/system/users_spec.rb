require 'rails_helper'

RSpec.xdescribe "Users", type: :system do
  describe 'ユーザ新規登録のテスト' do
    before do
      visit new_user_registration_path
    end

    it '新規登録に成功する' do
      fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
      fill_in 'user[email]', with: Faker::Internet.email
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button '登録する'
      expect(page).to have_content 'アカウント登録が完了しました。'
    end

    it '新規登録に失敗する' do
      fill_in 'user[name]', with: ''
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: ''
      fill_in 'user[password_confirmation]', with: ''
      click_button '登録する'
      expect(page).to have_content '正しく入力されていない項目があります'
    end
  end

  describe 'ユーザログインのテスト' do
    let(:test_user) { create(:user) }
    before do
      visit new_user_session_path
    end

    it 'ログインに成功する' do
      fill_in 'user[email]', with: test_user.email
      fill_in 'user[password]', with: test_user.password
      click_button 'ログイン'
      expect(current_path).to eq user_path(test_user)
    end

    it 'ログインに失敗する' do
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: ''
      click_button 'ログイン'
      expect(current_path).to eq new_user_session_path
    end
  end


  describe '詳細画面のテスト' do
    let(:lang) { create(:lang) }
    let(:test_user) { create(:user) }
    let!(:post_app) { create(:app, user: test_user, lang: lang) }
    let(:test_user_2) { create(:user) }
    let(:learning_app) { create(:app, user: test_user_2, lang: lang) }
    let!(:learning) { create(:learning, user: test_user, app: learning_app) }

    it 'ログインユーザの詳細ページ' do
      sign_in test_user
      visit user_path(test_user)

      aggregate_failures do
        expect(page).to have_link 'アカウント情報を編集', href: edit_user_path(test_user)
        expect(page).to have_content(post_app.title)
        expect(page).to have_link '内容を編集する', href: edit_app_path(post_app)
      end
    end

    it '他のユーザの詳細ページ' do
      sign_in test_user_2
      visit user_path(test_user)

      aggregate_failures do
        expect(page).not_to have_link 'アカウント情報を編集', href: edit_user_path(test_user)
        expect(page).not_to have_content learning_app.title
        expect(page).to have_content post_app.title
        expect(page).not_to have_link '内容を編集する', href: edit_app_path(post_app)
      end
    end
  end

  describe '編集画面のテスト' do
    let(:test_user) { create(:user) }

    it 'ログインユーザの編集ページ' do
      sign_in test_user
      visit edit_user_path(test_user)

      aggregate_failures do
        expect(page).to have_field 'user[name]', with: test_user.name
        expect(page).to have_field 'user[email]', with: test_user.email
        expect(page).to have_link 'パスワード変更', href: edit_user_registration_path
        expect(page).to have_link 'アカウント停止', href: quit_user_path(test_user)
      end
    end
  end

  describe 'ユーザ情報更新のテスト' do
    let(:test_user) { create(:user) }

    it 'ログインユーザのプロフィール更新' do
      sign_in test_user
      visit edit_user_path(test_user)

      fill_in "ユーザーネーム", with: "new_user_name"
      fill_in "自己紹介", with: "test_user_introduction"
      fill_in "スキル", with: "test_user_skill"
      click_button "更新する"

      aggregate_failures do
        expect(page).to have_current_path user_path(test_user)
        expect(page).to have_content "new_user_name"
        expect(page).to have_content "test_user_introduction"
        expect(page).to have_content "test_user_skill"
      end
    end

    it 'ログインユーザのパスワード変更' do
      sign_in test_user
      visit edit_user_registration_path

      fill_in "現在のパスワード", with: "password"
      fill_in "新しいパスワード", with: "newpassword"
      fill_in "新しいパスワード（確認用）", with: "newpassword"
      click_button "パスワードを変更"

      expect(page).to have_current_path root_path

      sign_out test_user
      visit new_user_session_path

      fill_in 'user[email]', with: test_user.email
      fill_in 'user[password]', with: "password"
      click_button 'ログイン'
      expect(current_path).to eq new_user_session_path

      fill_in 'user[email]', with: test_user.email
      fill_in 'user[password]', with: "newpassword"
      click_button 'ログイン'
      expect(current_path).to eq user_path(test_user)
    end

    it 'ログインユーザのアカウント停止', js: true do
      sign_in test_user
      visit quit_user_path(test_user)

      click_link "退会する"
      expect(page.driver.browser.switch_to.alert.text).to eq "退会してもよろしいですか？"
      page.driver.browser.switch_to.alert.accept

      sign_in test_user

      aggregate_failures do
        expect(page).to have_current_path new_user_session_path
        expect(page).to have_content "アカウントが有効化されていません。"
        expect(test_user.reload.status).to eq false
      end
    end
  end

  describe '学習アプリ画面・ストックアプリ画面のテスト' do
    let(:lang) { create(:lang) }
    let(:test_user) { create(:user) }
    let(:test_user_2) { create(:user) }
    let(:test_app) { create(:app, user: test_user_2, lang: lang) }
    let(:test_app_2) { create(:app, user: test_user_2, lang: lang) }
    let(:test_app_3) { create(:app, user: test_user_2, lang: lang) }
    let!(:learning) { create(:learning, user: test_user, app: test_app) }
    let!(:learned) { create(:learning, user: test_user, app: test_app_2, status: "学習済み") }
    let!(:learned_2) { create(:learning, user: test_user, app: test_app_3, status: "学習済み") }
    let!(:reviewed) { create(:review_2, user: test_user, app: test_app_3) }
    let!(:stock_1) { create(:stock, user: test_user, app: test_app) }
    let!(:stock_2) { create(:stock, user: test_user, app: test_app_2) }

    it 'ログインユーザの学習アプリ一覧ページ' do
      sign_in test_user
      visit learnings_user_path(test_user)

      aggregate_failures do
        expect(page).to have_link test_app.title, href: app_path(test_app)
        expect(page).to have_content "学習中"
        expect(page).to have_content "学習済み"
        expect(page).to have_link "レビューを投稿する", href: app_reviews_path(test_app_2)
        expect(page).to have_content "レビュー済み"
      end
    end

    it 'ログインユーザのストックアプリ一覧ページ' do
      sign_in test_user
      visit stocks_user_path(test_user)

      aggregate_failures do
        expect(page).to have_link test_app.title, href: app_path(test_app)
        expect(page).to have_link, href: app_stocks_path(test_app)
        expect(page).to have_link test_app_2.title, href: app_path(test_app_2)
        expect(page).to have_link, href: app_stocks_path(test_app_2)
      end
    end
  end
end
