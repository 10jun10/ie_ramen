require "rails_helper"

RSpec.describe "ユーザー一覧", type: :request do
  let!(:user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }

  context "許可されたユーザー(管理者)の場合" do
    it "正常なレスポンスを返すこと" do
      log_in(admin_user)
      get users_path
      expect(response).to have_http_status(:success)
      expect(response).to have_http_status "200"
    end
  end

  context "許可されていないユーザー(一般ログイン)の場合" do
    it "異常なレスポンスを返すこと" do
      log_in(user)
      get users_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end

  context "許可されていないユーザー(未ログイン)の場合" do
    it "異常なレスポンスを返すこと" do
      get users_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end

  context "adminの変更" do
    it "変更ができないこと" do
      log_in(user)
      expect(user.admin).to be_falsey
      patch user_path(user), params: { user: { password: user.password,
                                               password_confirmation: user.password,
                                               admin: true } }
      expect(user.reload.admin).to be_falsey
    end
  end
end
