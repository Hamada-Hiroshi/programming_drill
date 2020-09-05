require 'rails_helper'

RSpec.describe Notification, type: :model do
  describe '登録テスト' do
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let(:notification) { build(:follow_notice, visitor: user_a, visited: user_b) }

    it "vistor, visited, action, checkedがあれば有効" do
      expect(notification.valid?).to eq true
    end
  end
end
