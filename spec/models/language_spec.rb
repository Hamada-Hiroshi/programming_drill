require 'rails_helper'

RSpec.describe Language, type: :model do
  describe 'バリデーションのテスト' do
    subject { language.valid? }

    let(:language) { build(:language) }

    it "言語名があれば有効" do
      is_expected.to eq true
    end

    context 'nameカラム' do
      it '空欄でないこと' do
        language.name = ''
        is_expected.to eq false
      end
      it '重複して登録できない' do
        language_2 = create(:language)
        is_expected.to eq false
      end
    end
  end
end
