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

  describe '学習関連リンク、アプリ学習のテスト' do
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

  describe '詳細・編集画面、アプリ更新のテスト' do
    context '投稿ユーザの場合' do
      it 'アプリを更新できる' do
        sign_in test_user
        visit edit_app_path(post_app)

        aggregate_failures do
          expect(page).to have_field 'app[title]', with: post_app.title
          expect(page).to have_select 'app[lang_id]'
          expect(page).to have_link 'ヒントを追加・編集', href: hint_edit_app_path(post_app)
          expect(page).to have_link '解説を追加・編集', href: explanation_edit_app_path(post_app)
          expect(page).to have_link 'アプリを非公開にする', href: hidden_app_path(post_app)
        end
      end
    end

    context '他のユーザの場合' do
      it 'ページ遷移できない' do
        sign_in other_user
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
