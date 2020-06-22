require 'rails_helper'

RSpec.describe Learning, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:learning)).to be_valid
  end
end
