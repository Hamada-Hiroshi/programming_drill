require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'バリデーションのテスト' do
    subject { user.valid? }

    let(:user) { build(:user) }

    it "名前、メール、パスワードがあれば有効" do
      is_expected.to eq true
    end

    context 'nameカラム' do
      it '空欄でないこと' do
        user.name = ''
        is_expected.to eq false
      end
      it '30文字以下であること' do
        user.name = Faker::Lorem.characters(number: 31)
        is_expected.to eq false
      end
    end
  end
end
