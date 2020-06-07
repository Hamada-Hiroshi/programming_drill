require 'rails_helper'

RSpec.describe "Languages", type: :request do

  describe "GET /show" do
    it "returns http success" do
      get "/languages/show"
      expect(response).to have_http_status(:success)
    end
  end

end
