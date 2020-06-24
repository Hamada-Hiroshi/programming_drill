require 'rails_helper'

RSpec.describe Learning, type: :model do
  describe '登録テスト' do
    let(:user) { create(:user) }
    let(:app) { create(:app) }
    let!(:learning) { build(:learning, user_id: user.id, app_id: app.id) }

    it "ユーザIDとアプリIDのみで有効" do
      learning.memo = ''
      expect(learning.valid?).to eq true
    end
  end
end
