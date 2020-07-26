require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'バリデーションのテスト' do
    let(:question) { build(:question) }

    it "ユーザID、アプリID、質問内容があれば有効" do
      expect(question.valid?).to eq true
    end

    context 'contentカラム' do
      it '空欄でないこと' do
        question.content = ''
        expect(question.valid?).to eq false
      end
    end
  end
end
