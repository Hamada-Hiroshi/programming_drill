require 'rails_helper'

RSpec.describe "Reviews", type: :system do
  let(:test_user) { create(:user) }
  let(:post_user) { create(:user) }
  let(:test_app) { create(:app, user: post_user) }
  let!(:question) { create(:question, app: test_app) }

  describe '質問画面、質問（回答）投稿のテスト' do
    context '投稿ユーザの場合' do
      it '質問を投稿できない' do
        sign_in post_user
        visit app_questions_path(test_app)

        expect(page).to_not have_selector '#question-form .textarea-form'
      end

      it '回答を投稿できる', js: true do
        sign_in post_user
        visit app_questions_path(test_app)

        expect(page).to_not have_selector '.reply-form .textarea-form'
        click_link '質問に回答する'

        expect(page).to have_selector '.reply-form .textarea-form'
        expect {
          first(".reply-form .textarea-form").set("app_reply_content") 
          click_button '回答を送信'
          using_wait_time(7) do
            expect(page).to have_content 'app_reply_content'
          end
        }.to change(test_app.questions, :count).by(1)
      end
    end

    context '学習ユーザの場合' do
      let!(:learning) { create(:learning, user: test_user, app: test_app) }

      it '質問を投稿できる', js: true do
        sign_in test_user
        visit app_questions_path(test_app)

        expect(page).to have_selector '#question-form .textarea-form'
        expect {
          first("#question-form .textarea-form").set("app_question_content") 
          click_button '質問を投稿'
          using_wait_time(7) do
            expect(page).to have_content 'app_question_content'
          end
        }.to change(test_app.questions, :count).by(1)
      end

      it '回答を投稿できる', js: true do
        sign_in test_user
        visit app_questions_path(test_app)

        expect(page).to_not have_selector '.reply-form .textarea-form'
        click_link '質問に回答する'

        expect(page).to have_selector '.reply-form .textarea-form'
        expect {
          first(".reply-form .textarea-form").set("app_reply_content") 
          click_button '回答を送信'
          using_wait_time(7) do
            expect(page).to have_content 'app_reply_content'
          end
        }.to change(test_app.questions, :count).by(1)
      end
    end
  end
end