require 'rails_helper'

RSpec.describe App, type: :model do
  it "has a valid factory" do
    expect(FactoryBot.build(:app)).to be_valid
  end
end
