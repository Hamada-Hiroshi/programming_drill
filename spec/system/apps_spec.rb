require 'rails_helper'

describe 'アプリケーションのテスト' do
  let(:language) { create(:language) }
  let(:test_user) { create(:user) }
  let!(:post_app) { create(:app, user_id: test_user.id, language_id: language.id) }
  let(:test_user_2) { create(:user) }
  let(:learning_app) { create(:app, user_id: test_user_2.id, language_id: language.id) }
  let!(:learning) { create(:learning, user_id: test_user.id, app_id: learning_app.id) }

  describe '詳細画面リンクバーのテスト' do
    context 'ログインしていない場合' do
      before do
        visit app_path(post_app)
      end
      it 'アプリ詳細へのリンクが表示される' do
        expect(page).to have_link 'アプリ詳細', href: app_path(post_app)
      end
      it '学習メモへのリンクが表示されない' do
        expect(page).not_to have_link '学習メモ', href: app_learning_path(learning_app, learning)
      end
      it 'ヒントへのリンクが表示されない' do
        expect(page).not_to have_link 'ヒント', href: hint_app_path(post_app)
      end
      it '質問へのリンクが表示されない' do
        expect(page).not_to have_link '質問', href: app_questions_path(post_app)
      end
      it '解説へのリンクが表示されない' do
        expect(page).not_to have_link '解説', href: explanation_app_path(post_app)
      end
      it 'レビューへのリンクが表示される' do
        expect(page).to have_link 'レビュー', href: app_reviews_path(post_app)
      end
      it '編集ページへのリンクが表示されない' do
        expect(page).not_to have_link '編集', href: edit_app_path(post_app)
      end
      it '学習開始ボタンが表示される' do
        expect(page).to have_link '学習開始', href: app_learnings_path(post_app)
      end
      it '学習ボタンを押すとログインページへリダイレクトする' do
        click_link '学習開始'
        expect(current_path).to eq(new_user_session_path)
      end
      it '学習を開始するボタンが表示されない' do
        expect(page).not_to have_link '学習を開始する', href: app_learnings_path(post_app)
      end
    end

    context '投稿ユーザの場合' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: test_user.email
        fill_in 'user[password]', with: test_user.password
        click_button 'ログイン'
        visit app_path(post_app)
      end
      it 'アプリ詳細へのリンクが表示される' do
        expect(page).to have_link 'アプリ詳細', href: app_path(post_app)
      end
      it '学習メモへのリンクが表示されない' do
        expect(page).not_to have_link '学習メモ', href: app_learning_path(learning_app, learning)
      end
      it 'ヒントへのリンクが表示される' do
        expect(page).to have_link 'ヒント', href: hint_app_path(post_app)
      end
      it '質問へのリンクが表示される' do
        expect(page).to have_link '質問', href: app_questions_path(post_app)
      end
      it '解説へのリンクが表示される' do
        expect(page).to have_link '解説', href: explanation_app_path(post_app)
      end
      it 'レビューへのリンクが表示される' do
        expect(page).to have_link 'レビュー', href: app_reviews_path(post_app)
      end
      it '編集ページへのリンクが表示される' do
        expect(page).to have_link '編集', href: edit_app_path(post_app)
      end
      it '学習開始ボタンが表示されない' do
        expect(page).not_to have_link '学習開始', href: app_learnings_path(post_app)
      end
      it '学習を開始するボタンが表示されない' do
        expect(page).not_to have_link '学習を開始する', href: app_learnings_path(post_app)
      end
    end

    context '学習ユーザの場合' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: test_user.email
        fill_in 'user[password]', with: test_user.password
        click_button 'ログイン'
        visit app_path(learning_app)
      end
      it 'アプリ詳細へのリンクが表示される' do
        expect(page).to have_link 'アプリ詳細', href: app_path(learning_app)
      end
      it '学習メモへのリンクが表示される' do
        expect(page).to have_link '学習メモ', href: app_learning_path(learning_app, learning)
      end
      it 'ヒントへのリンクが表示される' do
        expect(page).to have_link 'ヒント', href: hint_app_path(learning_app)
      end
      it '質問へのリンクが表示される' do
        expect(page).to have_link '質問', href: app_questions_path(learning_app)
      end
      it '解説へのリンクが表示される' do
        expect(page).to have_link '解説', href: explanation_app_path(learning_app)
      end
      it 'レビューへのリンクが表示される' do
        expect(page).to have_link 'レビュー', href: app_reviews_path(learning_app)
      end
      it '編集ページへのリンクが表示されない' do
        expect(page).not_to have_link '編集', href: edit_app_path(learning_app)
      end
      it '学習開始ボタンが表示されない' do
        expect(page).not_to have_link '学習開始', href: app_learnings_path(learning_app)
      end
      it '学習を開始するボタンが表示されない' do
        expect(page).not_to have_link '学習を開始する', href: app_learnings_path(learning_app)
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
        visit edit_app_path(post_app)
      end
      it 'アプリケーション名編集フォームにタイトルが表示される' do
        expect(page).to have_field 'app[title]', with: post_app.title
      end
      it '開発言語編集フォームが表示される' do
        expect(page).to have_select 'app[language_id]'
      end
      it 'ヒント・解説編集ページリンクが表示される' do
        expect(page).to have_link 'ヒント・解説を追加・編集', href: add_edit_app_path(post_app)
      end
      it 'アプリ非公開ページリンクが表示される' do
        expect(page).to have_link 'アプリを非公開にする', href: hidden_app_path(post_app)
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
        visit edit_app_path(post_app)
        expect(current_path).to eq(root_path)
      end
    end

    context 'ログインしていない場合' do
      it 'ページ遷移できない' do
        visit edit_app_path(post_app)
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end

end