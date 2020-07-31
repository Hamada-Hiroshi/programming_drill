require 'rails_helper'

describe 'ユーザ認証のテスト' do
  context 'ユーザ新規登録' do
    before do
      visit new_user_registration_path
    end

    it '新規登録に成功する' do
      fill_in 'user[name]', with: Faker::Lorem.characters(number: 10)
      fill_in 'user[email]', with: Faker::Internet.email
      fill_in 'user[password]', with: 'password'
      fill_in 'user[password_confirmation]', with: 'password'
      click_button '登録する'
      expect(current_path).to eq(user_path(1))
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

  context 'ユーザログイン' do
    let(:test_user) { create(:user) }
    before do
      visit new_user_session_path
    end

    it 'ログインに成功する' do
      fill_in 'user[email]', with: test_user.email
      fill_in 'user[password]', with: test_user.password
      click_button 'ログイン'
      expect(current_path).to eq(user_path(test_user))
    end
    it 'ログインに失敗する' do
      fill_in 'user[email]', with: ''
      fill_in 'user[password]', with: ''
      click_button 'ログイン'
      expect(current_path).to eq(new_user_session_path)
    end
  end
end

describe 'ユーザのテスト' do
  let(:lang) { create(:lang) }
  let(:test_user) { create(:user) }
  let!(:post_app) { create(:app, user: test_user, lang: lang) }
  let(:test_user_2) { create(:user) }
  let(:learning_app) { create(:app, user: test_user_2, lang: lang) }
  let!(:learning) { create(:learning, user: test_user, app: learning_app) }

  context '詳細画面のテスト' do
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
        expect(page).not_to have_content(learning_app.title)
        expect(page).to have_content(post_app.title)
        expect(page).not_to have_link '内容を編集する', href: edit_app_path(post_app)
      end
    end

    it 'ログインしていない場合ログインページへリダイレクト' do
      visit user_path(test_user)
      expect(current_path).to eq(new_user_session_path)
    end
  end

  context '編集画面のテスト' do
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

    it '他のユーザの場合ページ遷移できない' do
      sign_in test_user_2
      visit edit_user_path(test_user)
      expect(current_path).to eq(root_path)
    end

    it 'ログインしていない場合ページ遷移できない' do
      visit edit_user_path(test_user)
      expect(current_path).to eq(new_user_session_path)
    end
  end
end
