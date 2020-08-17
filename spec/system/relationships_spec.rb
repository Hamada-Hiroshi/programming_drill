require 'rails_helper'

RSpec.describe "Relationships", type: :system do
  let(:following) { create(:user, name: "following_user_name") }
  let(:follower) { create(:user, name: "follower_user_name") }
  let(:test_app) { create(:app, user: follower) }

  describe 'フォロー機能、フォロー一覧画面のテスト', js: true do
    it 'フォロー/フォロー解除のテスト' do
      sign_in following
      visit app_path(test_app)
      first('.app-post img.profile_image').click

      expect(page).to have_link 'フォロワー数 0人'
      expect {
        click_link 'フォローする'
        using_wait_time(7) do
          expect(page).to have_link 'フォロー中'
          expect(page).to have_link 'フォロワー数 1人'
        end
      }.to change(following.active_relationships, :count).by(1)

      expect {
        click_link 'フォロー中'
        using_wait_time(7) do
          expect(page).to have_link 'フォローする'
          expect(page).to have_link 'フォロワー数 0人'
        end
      }.to change(following.active_relationships, :count).by(-1)
    end

    it 'フォロー/フォロワー一覧画面のテスト' do
      sign_in following
      visit following_user_path(following)
      aggregate_failures do
        expect(page).to_not have_content 'follower_user_name'
        expect(page).to have_link 'フォロー数 0人'
      end

      visit followers_user_path(follower)
      aggregate_failures do
        expect(page).to_not have_content 'following_user_name'
        expect(page).to have_link 'フォロワー数 0人'
      end

      visit app_path(test_app)
      first('.app-post img.profile_image').click
      click_link 'フォローする'

      visit following_user_path(following)
      aggregate_failures do
        expect(page).to have_content 'follower_user_name'
        expect(page).to have_link 'フォロー数 1人'
      end

      visit followers_user_path(follower)
      aggregate_failures do
        expect(page).to have_content 'following_user_name'
        expect(page).to have_link 'フォロワー数 1人'
      end
    end
  end
end