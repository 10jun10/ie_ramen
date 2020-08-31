require "rails_helper"

RSpec.describe "ユーザー一覧", type: :request do
  let!(:user) { create(:user) }

  context "許可されたユーザー(ログイン済み)の場合" do
    it "正常なレスポンスを返すこと" do
      log_in(user)
      get users_path
      expect(response).to have_http_status(:success)
      expect(response).to have_http_status "200"
    end
  end

  context "許可されていないユーザー(未ログイン)の場合" do
    it "正常なレスポンスを返すこと" do
      get users_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
