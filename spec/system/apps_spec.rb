require 'rails_helper'

xRSpec.describe "Apps", type: :system do
  let(:test_user) { create(:user) }

  describe '一覧画面のテスト' do
    let(:other_user_1) { create(:user) }
    let(:other_user_2) { create(:user) }
    let(:other_user_3) { create(:user) }
    let(:lang) { create(:lang) }
    #r => reviewの評価点, l => learningの数
    let!(:app_r2_l3) { create(:app, user: test_user, lang: lang, title: "新着3 評価3 人気1") }
    let!(:app_r4_l1) { create(:app, user: test_user, lang: lang, title: "新着2 評価1 人気3") }
    let!(:app_r3_l2) { create(:app, user: test_user, lang: lang, title: "新着1 評価2 人気2") }
    let!(:learning_1) { create(:learning, user: other_user_1, app: app_r2_l3, status: "学習済み") }
    let!(:learning_2) { create(:learning, user: other_user_2, app: app_r2_l3, status: "学習済み") }
    let!(:learning_3) { create(:learning, user: other_user_3, app: app_r2_l3, status: "学習済み") }
    let!(:learning_4) { create(:learning, user: other_user_1, app: app_r4_l1, status: "学習済み") }
    let!(:learning_5) { create(:learning, user: other_user_1, app: app_r3_l2, status: "学習済み") }
    let!(:learning_6) { create(:learning, user: other_user_2, app: app_r3_l2, status: "学習済み") }
    let!(:review_1) { create(:review_1, user: other_user_1, app: app_r2_l3) }
    let!(:review_2) { create(:review_2, user: other_user_2, app: app_r2_l3) }
    let!(:review_3) { create(:review_3, user: other_user_3, app: app_r2_l3) }
    let!(:review_4) { create(:review_4, user: other_user_1, app: app_r4_l1) }
    let!(:review_5) { create(:review_1, user: other_user_1, app: app_r3_l2) }
    let!(:review_6) { create(:review_5, user: other_user_2, app: app_r3_l2) }

    it 'アプリ一覧の並び替えテスト' do
      visit root_path
      @apps = page.all(".link-app-info")

      aggregate_failures do
        expect(@apps[0].find('h4').text).to eq "新着1 評価2 人気2"
        expect(@apps[1].find('h4').text).to eq "新着2 評価1 人気3"
        expect(@apps[2].find('h4').text).to eq "新着3 評価3 人気1"
      end

      click_link '評価順'
      @apps = page.all(".link-app-info")

      aggregate_failures do
        expect(@apps[0].find('h4').text).to eq "新着2 評価1 人気3"
        expect(@apps[1].find('h4').text).to eq "新着1 評価2 人気2"
        expect(@apps[2].find('h4').text).to eq "新着3 評価3 人気1"
        expect(@apps[0].first('span').text).to eq "（4.0）"
        expect(@apps[1].first('span').text).to eq "（3.0）"
        expect(@apps[2].first('span').text).to eq "（2.0）"
      end

      click_link '人気順'
      @apps = page.all(".link-app-info")

      aggregate_failures do
        expect(@apps[0].find('h4').text).to eq "新着3 評価3 人気1"
        expect(@apps[1].find('h4').text).to eq "新着1 評価2 人気2"
        expect(@apps[2].find('h4').text).to eq "新着2 評価1 人気3"
        expect(@apps[0].find('span.learning-count').text).to eq "学習者：3人"
        expect(@apps[1].find('span.learning-count').text).to eq "学習者：2人"
        expect(@apps[2].find('span.learning-count').text).to eq "学習者：1人"
      end
    end
  end

  describe '新規投稿のテスト', js: true do
    let!(:lang) { create(:lang) }
    before do
      sign_in test_user
      visit new_app_path
      fill_in 'app[title]', with: "new_app_title"
      select "Ruby", from: 'app[lang_id]'
      fill_in 'app[overview]', with: "new_app_orverview"
      fill_in 'app[app_url]', with: "https://new_app_app_url@example.com"
      fill_in 'app[repo_url]', with: "https://new_app_repo_url@example.com"
      fill_in 'app[function]', with: "new_app_function"
      fill_in 'app[target]', with: "new_app_target"
      first("li.tagit-new > input[type='text']").set("HTML,")
      first("li.tagit-new > input[type='text']").set("CSS,")
    end

    it '確認ページ表示後すぐに投稿' do
      click_button '確認ページへ進む'
      aggregate_failures do
        expect(page).to have_current_path confirm_apps_path
        expect(page).to have_content 'new_app_title'
        expect(page).to have_link 'https://new_app_app_url@example.com'
        expect(page).to have_content 'new_app_function'
        expect(page).to have_content 'HTML'
      end

      expect {
        click_link '投稿する'
      }.to change(test_user.apps, :count).by(1)

      aggregate_failures do
        expect(page).to have_link 'Ruby'
        expect(page).to have_link 'https://new_app_repo_url@example.com'
        expect(page).to have_content 'new_app_target'
        expect(page).to have_link 'CSS'
      end
    end

    it '確認ページ表示後一度編集し直してから投稿' do
      click_button '確認ページへ進む'
      click_link '入力ページに戻る'

      aggregate_failures do
        expect(page).to have_selector 'input#app_title[value="new_app_title"]'
        expect(page).to have_selector 'select#app_lang_id > option[selected="selected"]', text: 'Ruby'
        expect(page).to have_selector 'li.tagit-choice > span.tagit-label', text: 'HTML'
        expect(page).to have_selector 'li.tagit-choice > span.tagit-label', text: 'CSS'
      end

      fill_in 'app[overview]', with: "edit_app_orverview"
      fill_in 'app[app_url]', with: "https://edit_app_app_url@example.com"
      first("li.tagit-new > input[type='text']").set("RubyonRails,")
      click_button '確認ページへ進む'

      aggregate_failures do
        expect(page).to have_current_path confirm_apps_path
        expect(page).to have_content 'new_app_title'
        expect(page).to have_link 'https://edit_app_app_url@example.com'
        expect(page).to have_content 'HTML'
        expect(page).to have_content 'RubyonRails'
      end

      expect {
        click_link '投稿する'
      }.to change(test_user.apps, :count).by(1)

      aggregate_failures do
        expect(page).to have_link 'Ruby'
        expect(page).to have_content 'edit_app_orverview'
        expect(page).to have_link 'CSS'
        expect(page).to have_link 'RubyonRails'
      end
    end
  end

  describe '詳細画面、アプリ学習のテスト' do
    let(:lang) { create(:lang) }
    let!(:post_app) { create(:app, user: test_user, lang: lang) }
    let(:other_user) { create(:user) }

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
    let(:lang) { create(:lang) }
    let!(:post_app) { create(:app, user: test_user, lang: lang) }

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
      visit edit_app_path(post_app)
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
      visit edit_app_path(post_app)
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
