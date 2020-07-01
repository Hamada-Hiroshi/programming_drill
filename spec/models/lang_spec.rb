require 'rails_helper'

RSpec.describe Lang, type: :model do
  describe 'バリデーションのテスト' do
    subject { lang.valid? }

    let(:lang) { build(:lang) }

    it "言語名があれば有効" do
      is_expected.to eq true
    end

    context 'nameカラム' do
      it '空欄でないこと' do
        lang.name = ''
        is_expected.to eq false
      end
      it '重複して登録できない' do
        lang_2 = create(:lang)
        is_expected.to eq false
      end
    end
  end
end
