require 'rails_helper'

RSpec.describe "プロフィール", type: :request do
  describe "GET /show" do
    let!(:user) { create(:user) }

    it "レスポンスが正常に表示されること" do
      log_in(user)
      get user_path(user)
      expect(response).to have_http_status(:success)
      expect(response).to have_http_status "200"
    end
  end
end
