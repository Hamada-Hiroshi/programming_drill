require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'バリデーションのテスト' do
    let(:user) { create(:user) }
    let(:app) { create(:app) }
    let!(:review) { build(:review_2, user_id: user.id, app_id: app.id) }

    it "ユーザID、アプリID、レビュー内容、評価点があれば有効" do
      expect(review.valid?).to eq true
    end

    context 'contentカラム' do
      it '空欄でないこと' do
        review.content = ''
        expect(review.valid?).to eq false
      end
    end

    context 'rateカラム' do
      it '空欄でないこと' do
        review.content = ''
        expect(review.valid?).to eq false
      end
      it '1未満でないこと' do
        review.rate = 0.5
        expect(review.valid?).to eq false
      end
      it '5以下であること' do
        review.rate = 6.0
        expect(review.valid?).to eq false
      end
    end
  end
end
