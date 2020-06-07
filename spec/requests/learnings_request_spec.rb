require 'rails_helper'

RSpec.describe "Learnings", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/learnings/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/learnings/edit"
      expect(response).to have_http_status(:success)
    end
  end

end
