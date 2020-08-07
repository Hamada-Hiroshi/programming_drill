require 'rails_helper'

RSpec.describe "Apps", type: :system do
  let(:lang) { create(:lang) }
  let(:test_user) { create(:user) }
  let!(:post_app) { create(:app, user: test_user, lang: lang) }
  let(:other_user) { create(:user) }

  describe '一覧画面のテスト' do
    it 'アプリ一覧の並び替えテスト' do

    end
  end

  describe '詳細画面、アプリ学習のテスト' do
    context '投稿ユーザの場合' do
      it '学習はできないがリンクは全て表示' do
        sign_in test_user
        visit app_path(post_app)

        aggregate_failures do
          expect(page).to have_link 'アプリ詳細', href: app_path(post_app)
          expect(page).not_to have_content '学習メモ'
          expect(page).to have_link 'ヒント', href: hint_app_path(post_app)
          expect(page).to have_link '質問', href: app_questions_path(post_app)
          expect(page).to have_link '解説', href: explanation_app_path(post_app)
          expect(page).to have_link 'レビュー', href: app_reviews_path(post_app)
          expect(page).to have_link '編集', href: edit_app_path(post_app)
          expect(page).not_to have_link '学習開始', href: app_learnings_path(post_app)
          expect(page).not_to have_link 'このアプリケーションを作成する', href: app_learnings_path(post_app)
        end
      end
    end

    context '他のユーザ（未学習者）の場合' do
      it '学習を開始すると全てのリンクが表示' do
        sign_in other_user
        visit app_path(post_app)

        aggregate_failures do
          expect(page).to have_link 'アプリ詳細', href: app_path(post_app)
          expect(page).not_to have_content '学習メモ'
          expect(page).not_to have_link 'ヒント', href: hint_app_path(post_app)
          expect(page).not_to have_link '質問', href: app_questions_path(post_app)
          expect(page).not_to have_link '解説', href: explanation_app_path(post_app)
          expect(page).to have_link 'レビュー', href: app_reviews_path(post_app)
          expect(page).not_to have_link '編集', href: edit_app_path(post_app)
          expect(page).to have_link '学習開始', href: app_learnings_path(post_app)
          expect(page).to have_link 'このアプリケーションを作成する', href: app_learnings_path(post_app)
        end

        click_link "学習開始"
        @learning = Learning.find_by(user: other_user, app: post_app)

        aggregate_failures do
          expect(page).to have_content '学習中'
          expect(page).to have_link 'アプリ詳細', href: app_path(post_app)
          expect(page).to have_link '学習メモ', href: app_learning_path(post_app, @learning)
          expect(page).to have_link 'ヒント', href: hint_app_path(post_app)
          expect(page).to have_link '質問', href: app_questions_path(post_app)
          expect(page).to have_link '解説', href: explanation_app_path(post_app)
          expect(page).to have_link 'レビュー', href: app_reviews_path(post_app)
          expect(page).not_to have_link '編集', href: edit_app_path(post_app)
          expect(page).not_to have_link '学習開始', href: app_learnings_path(post_app)
          expect(page).not_to have_link 'このアプリケーションを作成する', href: app_learnings_path(post_app)
        end
      end
    end

    context 'ログインしていない場合' do
      it '学習は出来ずリンクも表示されない' do
        visit app_path(post_app)

        aggregate_failures do
          expect(page).to have_link 'アプリ詳細', href: app_path(post_app)
          expect(page).not_to have_content '学習メモ'
          expect(page).not_to have_link 'ヒント', href: hint_app_path(post_app)
          expect(page).not_to have_link '質問', href: app_questions_path(post_app)
          expect(page).not_to have_link '解説', href: explanation_app_path(post_app)
          expect(page).to have_link 'レビュー', href: app_reviews_path(post_app)
          expect(page).not_to have_link '編集', href: edit_app_path(post_app)
          expect(page).to have_link '学習開始', href: app_learnings_path(post_app)
          expect(page).not_to have_link 'このアプリケーションを作成する', href: app_learnings_path(post_app)
        end

        click_link '学習開始'
        expect(current_path).to eq(new_user_session_path)
      end
    end
  end

  describe '編集画面、アプリ更新のテスト' do
    it 'アプリの基本情報を更新' do
      sign_in test_user
      visit app_path(post_app)
      click_link '編集'

      aggregate_failures do
        expect(page).to have_field 'app[title]', with: post_app.title
        expect(page).to have_select 'app[lang_id]'
        expect(page).to have_link 'ヒントを追加・編集', href: hint_edit_app_path(post_app)
        expect(page).to have_link '解説を追加・編集', href: explanation_edit_app_path(post_app)
        expect(page).to have_link 'アプリを非公開にする', href: hidden_app_path(post_app)
      end

      fill_in 'app[overview]', with: 'new_app_title'
      fill_in 'app[app_url]', with: 'new_app_url@example.com'
      click_button "更新する"

      aggregate_failures do
        expect(page).to have_current_path app_path(post_app)
        expect(page).to have_content 'new_app_title'
        expect(page).to have_content 'new_app_url@example.com'
      end
    end

    it 'アプリのヒントを更新', js: true do
      sign_in test_user
      visit hint_app_path(post_app)

      expect(page).to have_content 'ヒントは投稿されていません。'
      click_link '編集'
      click_link 'ヒントを追加・編集'

      expect(page).to have_field 'app[hint]', with: ''
      fill_in 'app[hint]', with: '##new_app_hint'

      expect(page).to have_selector 'div#marked-area h2', text: 'new_app_hint'
      click_button "更新する"

      aggregate_failures do
        expect(page).to have_current_path hint_app_path(post_app)
        expect(page).to have_selector 'div#marked-text h2', text: 'new_app_hint'
      end
    end

    it 'アプリの解説を更新', js: true do
      sign_in test_user
      visit explanation_app_path(post_app)

      expect(page).to have_content '解説は投稿されていません。'
      click_link '編集'
      click_link '解説を追加・編集'

      expect(page).to have_field 'app[explanation]', with: ''
      fill_in 'app[explanation]', with: '- new_app_explanation'

      expect(page).to have_selector 'div#marked-area ul li', text: 'new_app_explanation'
      click_button "更新する"

      aggregate_failures do
        expect(page).to have_current_path explanation_app_path(post_app)
        expect(page).to have_selector 'div#marked-text ul li', text: 'new_app_explanation'
      end
    end

    it 'アプリを非公開にする', js: true do
      visit root_path
      expect(page).to have_link post_app[title], href: app_path(post_app)

      sign_in test_user
      visit edit_app_path(post_app)
      click_link 'アプリを非公開にする'

      click_link 'アプリの公開を停止'
      expect(page.driver.browser.switch_to.alert.text).to eq 'アプリを非公開にしてもよろしいですか？'
      page.driver.browser.switch_to.alert.accept

      aggregate_failures do
        expect(page).to have_current_path user_path(test_user)
        expect(page).to have_content '非公開済みのアプリです'
        expect(post_app.reload.status).to eq false
      end

      visit root_path
      expect(page).to_not have_link post_app[title], href: app_path(post_app)
    end
  end
end
