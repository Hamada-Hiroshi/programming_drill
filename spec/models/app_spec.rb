require 'rails_helper'

RSpec.describe App, type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:lang) { create(:lang) }
    let!(:app) { create(:app, user_id: user.id, lang_id: lang.id) }

    it "タイトル、概要、アプリURL、リポジトリURL、機能、対象があれば有効" do
      expect(app.valid?).to eq true
    end

    context 'titleカラム' do
      it '空欄でないこと' do
        app.title = ''
        expect(app.valid?).to eq false
      end
      it '25文字以下であること' do
        app.title = Faker::Lorem.characters(number: 26)
        expect(app.valid?).to eq false
      end
      it '重複して登録できない' do
        app_2 = build(:app, user_id: user.id, lang_id: lang.id)
        app_2.title = app.title
        expect(app_2.valid?).to eq false
      end
    end

    context 'overviewカラム' do
      it '空欄でないこと' do
        app.overview = ''
        expect(app.valid?).to eq false
      end
    end

    context 'app_urlカラム' do
      it '空欄でないこと' do
        app.app_url = ''
        expect(app.valid?).to eq false
      end
      it 'URLの正規表現であること' do
        app.app_url = Faker::Lorem.characters(number: 20)
        expect(app.valid?).to eq false
      end
    end

    context 'repo_urlカラム' do
      it '空欄でないこと' do
        app.repo_url = ''
        expect(app.valid?).to eq false
      end
      it 'URLの正規表現であること' do
        app.repo_url = Faker::Lorem.characters(number: 20)
        expect(app.valid?).to eq false
      end
    end

    context 'functionカラム' do
      it '空欄でないこと' do
        app.function = ''
        expect(app.valid?).to eq false
      end
    end

    context 'targetカラム' do
      it '空欄でないこと' do
        app.target = ''
        expect(app.valid?).to eq false
      end
    end
  end
end
