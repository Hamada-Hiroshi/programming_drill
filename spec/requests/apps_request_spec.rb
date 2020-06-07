require 'rails_helper'

RSpec.describe "Apps", type: :request do

  describe "GET /index" do
    it "returns http success" do
      get "/apps/index"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /new" do
    it "returns http success" do
      get "/apps/new"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /confirm" do
    it "returns http success" do
      get "/apps/confirm"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /show" do
    it "returns http success" do
      get "/apps/show"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /edit" do
    it "returns http success" do
      get "/apps/edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /add_edit" do
    it "returns http success" do
      get "/apps/add_edit"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /hint" do
    it "returns http success" do
      get "/apps/hint"
      expect(response).to have_http_status(:success)
    end
  end

  describe "GET /explanation" do
    it "returns http success" do
      get "/apps/explanation"
      expect(response).to have_http_status(:success)
    end
  end

end
