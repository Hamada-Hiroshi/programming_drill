require 'rails_helper'

RSpec.describe "Reviews", type: :system do
  let(:test_user) { create(:user) }
  let(:post_user) { create(:user) }
  let(:test_app) { create(:app, user: post_user) }

  describe 'レビュー画面、レビュー投稿のテスト' do
    context 'ログインしていない場合' do
      it 'レビューを投稿できない' do
        visit app_reviews_path(test_app)

        aggregate_failures do
          expect(page).to_not have_selector 'div#manual-rating'
          expect(page).to_not have_selector 'div#auto-rating'
          expect(page).to_not have_field 'review[content]'
          expect(page).to have_text '学習済みのアプリケーションのみ、レビューを投稿できます。'
        end
      end
    end

    context '投稿ユーザの場合' do
      it 'レビューを投稿できない' do
        sign_in post_user
        visit app_reviews_path(test_app)

        aggregate_failures do
          expect(page).to_not have_selector 'div#manual-rating'
          expect(page).to_not have_selector 'div#auto-rating'
          expect(page).to_not have_field 'review[content]'
        end
      end
    end

    context '学習中ユーザの場合' do
      let!(:learning) { create(:learning, user: test_user, app: test_app) }

      it 'レビューを投稿できない' do
        sign_in test_user
        visit app_reviews_path(test_app)

        aggregate_failures do
          expect(page).to_not have_selector 'div#manual-rating'
          expect(page).to_not have_selector 'div#auto-rating'
          expect(page).to_not have_field 'review[content]'
          expect(page).to have_text '学習済みのアプリケーションのみ、レビューを投稿できます。'
        end
      end
    end

    context '学習済みユーザの場合', js: true do
      let!(:learned) { create(:learning, user: test_user, app: test_app, status: '学習済み') }

      it 'レビューを投稿できる（点数手動入力）' do
        sign_in test_user
        visit app_reviews_path(test_app)

        aggregate_failures do
          expect(page).to have_selector 'div#manual-rating'
          expect(page).to have_selector 'div#auto-rating'
          expect(page).to have_field 'review[content]'
          expect(page).to_not have_text '学習済みのアプリケーションのみ、レビューを投稿できます。'
        end

        expect {
          page.all('#star > img')[2].click
          fill_in 'review[content]', with: "app_review_content"
          click_button 'レビューを投稿'
          using_wait_time(7) do
            expect(page).to have_text 'このアプリケーションはすでにレビュー済みです。'
          end
        }.to change(test_app.reviews, :count).by(1)

        aggregate_failures do
          expect(page).to_not have_selector 'div#manual-rating'
          expect(page).to_not have_selector 'div#auto-rating'
          expect(page).to_not have_field 'review[content]'
          expect(page).to have_selector 'div.post-content', text: 2.5
          expect(page).to have_content 'app_review_content'
        end

      end

      it 'レビューを投稿できる（点数自動判定）' do

      end
    end
  end
end
