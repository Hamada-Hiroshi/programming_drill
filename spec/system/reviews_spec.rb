require 'rails_helper'

describe 'レビューのテスト' do
  let(:lang) { create(:lang) }
  let(:test_user) { create(:user) }
  let!(:post_app) { create(:app, user: test_user, lang: lang) }
  let(:test_user_2) { create(:user) }
  let(:learning_app) { create(:app, user: test_user_2, lang: lang) }
  let!(:learning) { create(:learning, user: test_user, app: learning_app) }
  let(:learned_app) { create(:app, user: test_user_2, lang: lang) }
  let!(:learned) { create(:learning, user: test_user, app: learned_app, status: '学習済み') }

  context 'レビュー画面のテスト' do
    it 'ログインしていない場合レビューを投稿できない' do
      visit app_reviews_path(learned_app)

      aggregate_failures do
        expect(page).not_to have_text '星の数を選択'
        expect(page).not_to have_field 'review[content]'
        expect(page).to have_text '学習済みのアプリケーションのみ、レビューを投稿できます。'
      end
    end

    it '投稿ユーザの場合レビューを投稿できない' do
      sign_in test_user
      visit app_reviews_path(post_app)

      aggregate_failures do
        expect(page).not_to have_text '星の数を選択'
        expect(page).not_to have_field 'review[content]'
        expect(page).not_to have_text '学習済みのアプリケーションのみ、レビューを投稿できます。'
      end
    end

    it '学習中ユーザの場合レビューを投稿できない' do
      sign_in test_user
      visit app_reviews_path(learning_app)

      aggregate_failures do
        expect(page).not_to have_text '星の数を選択'
        expect(page).not_to have_field 'review[content]'
        expect(page).to have_text '学習済みのアプリケーションのみ、レビューを投稿できます。'
      end
    end

    it '学習済みユーザの場合レビュー投稿フォームが表示される' do
      sign_in test_user
      visit app_reviews_path(learned_app)

      aggregate_failures do
        expect(page).to have_text 'レビュー内容から自動で評価を判定する。'
        expect(page).to have_field 'review[content]'
        expect(page).not_to have_text '学習済みのアプリケーションのみ、レビューを投稿できます。'
      end
    end
  end
end
