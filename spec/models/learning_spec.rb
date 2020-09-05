require 'rails_helper'

RSpec.describe Learning, type: :model do
  describe '登録テスト' do
    let(:learning) { build(:learning) }

    it "ユーザIDとアプリIDのみで有効" do
      learning.memo = ''
      expect(learning.valid?).to eq true
    end
  end
end
