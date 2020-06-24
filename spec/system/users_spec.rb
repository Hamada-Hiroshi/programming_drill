require 'rails_helper'

describe 'ユーザ認証のテスト' do
  describe 'ユーザ新規登録' do
    before do
      visit new_user_registration_path
    end
    context '新規登録画面に遷移' do
      it '新規登録に成功する' do
        fill_in 'user[name]', with: Faker::Lorem.characters(number:10)
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
  end

  describe 'ユーザログイン' do
    let(:test_user) { create(:user) }
    before do
      visit new_user_session_path
    end
    context 'ログイン画面に遷移' do
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
end

describe 'ユーザのテスト' do
  let(:language) { create(:language) }
  let(:test_user) { create(:user) }
  let!(:post_app) { create(:app, user_id: test_user.id, language_id: language.id) }
  let(:test_user_2) { create(:user) }
  let(:learning_app) { create(:app, user_id: test_user_2.id, language_id: language.id) }
  let!(:learning) { create(:learning, user_id: test_user.id, app_id: learning_app.id) }

  describe '詳細画面のテスト' do
    context 'ログインユーザの詳細ページ' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: test_user.email
        fill_in 'user[password]', with: test_user.password
        click_button 'ログイン'
        visit user_path(test_user)
      end
      it 'プロフィール編集リンクが表示される' do
        expect(page).to have_link 'アカウント情報を編集', href: edit_user_path(test_user)
      end
      it '学習アプリ一覧が表示される' do
        expect(page).to have_content(learning_app.title)
      end
      it '投稿アプリ一覧が表示される' do
        expect(page).to have_content(post_app.title)
      end
      it '投稿アプリの編集リンクが表示される' do
        expect(page).to have_link '内容を編集する', href: edit_app_path(post_app)
      end
    end

    context '他のユーザの詳細ページ' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: test_user_2.email
        fill_in 'user[password]', with: test_user_2.password
        click_button 'ログイン'
        visit user_path(test_user)
      end
      it 'プロフィール編集リンクが表示されない' do
        expect(page).not_to have_link 'アカウント情報を編集', href: edit_user_path(test_user)
      end
      it '学習アプリ一覧が表示されない' do
        expect(page).not_to have_content(learning_app.title)
      end
      it '投稿アプリ一覧が表示される' do
        expect(page).to have_content(post_app.title)
      end
      it '投稿アプリの編集リンクが表示されない' do
        expect(page).not_to have_link '内容を編集する', href: edit_app_path(post_app)
      end
    end

    context 'ログインしていない場合' do
      it 'ログインページへリダイレクトする' do
        visit user_path(test_user)
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end

  describe '編集画面のテスト' do
    context 'ログインユーザの場合' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: test_user.email
        fill_in 'user[password]', with: test_user.password
        click_button 'ログイン'
        visit edit_user_path(test_user)
      end
      it 'ユーザネーム編集フォームに自分の名前が表示される' do
        expect(page).to have_field 'user[name]', with: test_user.name
      end
      it 'メールアドレス編集フォームに自分のアドレスが表示される' do
        expect(page).to have_field 'user[email]', with: test_user.email
      end
      it 'パスワード変更ページリンクが表示される' do
        expect(page).to have_link 'パスワード変更', href: edit_user_registration_path
      end
      it 'アカウント削除ページリンクが表示される' do
        expect(page).to have_link 'アカウント削除', href: quit_user_path(test_user)
      end
    end

    context '他のユーザの場合' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: test_user_2.email
        fill_in 'user[password]', with: test_user_2.password
        click_button 'ログイン'
      end
      it 'ページ遷移できない' do
        visit edit_user_path(test_user)
        expect(current_path).to eq(root_path)
      end
    end

    context 'ログインしていない場合' do
      it 'ページ遷移できない' do
        visit edit_user_path(test_user)
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end

end
