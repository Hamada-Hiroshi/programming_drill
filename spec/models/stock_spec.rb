require 'rails_helper'

RSpec.describe Stock, type: :model do
  describe '登録テスト' do
    let(:stock) { build(:stock) }

    it "ユーザIDとアプリIDで有効" do
      expect(stock.valid?).to eq true
    end
  end
end
