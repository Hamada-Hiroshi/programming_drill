require 'rails_helper'

describe 'レビューのテスト' do
  let(:language) { create(:language) }
  let(:test_user) { create(:user) }
  let!(:post_app) { create(:app, user_id: test_user.id, language_id: language.id) }
  let(:test_user_2) { create(:user) }
  let(:learning_app) { create(:app, user_id: test_user_2.id, language_id: language.id) }
  let!(:learning) { create(:learning, user_id: test_user.id, app_id: learning_app.id) }
  let(:learned_app) { create(:app, user_id: test_user_2.id, language_id: language.id) }
  let!(:learned) { create(:learning, user_id: test_user.id, app_id: learned_app.id, status: '学習済み') }

  describe 'レビュー画面のテスト' do
    context 'ログインしていない場合' do
      before do
        visit app_reviews_path(learned_app)
      end

      it 'スコア入力フォームは表示されない' do
        expect(page).not_to have_text '星の数を選択'
      end
      it 'レビュー入力フォームは表示されない' do
        expect(page).not_to have_field 'review[content]'
      end
      it '入力条件が表示される' do
        expect(page).to have_text '学習済みのアプリケーションのみ、レビューを投稿できます。'
      end
    end

    context '投稿ユーザの場合' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: test_user.email
        fill_in 'user[password]', with: test_user.password
        click_button 'ログイン'
        visit app_reviews_path(post_app)
      end

      it 'スコア入力フォームは表示されない' do
        expect(page).not_to have_text '星の数を選択'
      end
      it 'レビュー入力フォームは表示されない' do
        expect(page).not_to have_field 'review[content]'
      end
      it '入力条件が表示されない' do
        expect(page).not_to have_text '学習済みのアプリケーションのみ、レビューを投稿できます。'
      end
    end

    context '学習中ユーザの場合' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: test_user.email
        fill_in 'user[password]', with: test_user.password
        click_button 'ログイン'
        visit app_reviews_path(learning_app)
      end

      it 'スコア入力フォームは表示されない' do
        expect(page).not_to have_text '星の数を選択'
      end
      it 'レビュー入力フォームは表示されない' do
        expect(page).not_to have_field 'review[content]'
      end
      it '入力条件が表示される' do
        expect(page).to have_text '学習済みのアプリケーションのみ、レビューを投稿できます。'
      end
    end

    context '学習済みユーザの場合' do
      before do
        visit new_user_session_path
        fill_in 'user[email]', with: test_user.email
        fill_in 'user[password]', with: test_user.password
        click_button 'ログイン'
        visit app_reviews_path(learned_app)
      end

      it 'スコア入力フォームが表示される' do
        expect(page).to have_text '星の数を選択'
      end
      it 'レビュー入力フォームが表示される' do
        expect(page).to have_field 'review[content]'
      end
      it '入力条件が表示されない' do
        expect(page).not_to have_text '学習済みのアプリケーションのみ、レビューを投稿できます。'
      end
    end
  end
end
