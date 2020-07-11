require 'rails_helper'

RSpec.describe "Admin::Apps", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/admin/apps/index"
      expect(response).to have_http_status(:success)
    end
  end

end
