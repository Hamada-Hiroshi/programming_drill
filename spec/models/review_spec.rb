require 'rails_helper'

RSpec.describe Review, type: :model do
  describe 'バリデーションのテスト' do
    let(:review) { build(:review_2) }

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
      it '1以上であること' do
        review.rate = 0.9
        expect(review.valid?).to eq false
      end
      it '5以下であること' do
        review.rate = 5.1
        expect(review.valid?).to eq false
      end
    end
  end
end
