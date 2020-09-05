require 'rails_helper'

RSpec.describe Relationship, type: :model do
  describe '登録テスト' do
    let(:user_a) { create(:user) }
    let(:user_b) { create(:user) }
    let(:relationship) { build(:relationship, following: user_a, follower: user_b) }

    it "followingとfollowerで有効" do
      expect(relationship.valid?).to eq true
    end
  end
end
