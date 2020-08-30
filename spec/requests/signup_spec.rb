require "rails_helper"

RSpec.describe "アカウント作成", type: :request do
  describe "GET /new" do
    before do
      get signup_path
    end

    it "正常なレスポンスを返すこと" do
      expect(response).to have_http_status(:success)
      expect(response).to have_http_status "200"
    end

    it "有効なユーザーで登録" do
      expect {
        post users_path, params: { user: { name: "test",
                                           email: "test@example.com",
                                           password: "password",
                                           password_confirmation: "password" } }
      }.to change(User, :count).by(1)
      redirect_to @user
      follow_redirect!
      expect(response).to render_template('users/show')
      expect(is_logged_in?).to be_truthy
    end

    it "無効なユーザーで登録" do
      expect {
        post users_path, params: { user: { name: "",
                                           email: "test@example.com",
                                           password: "password",
                                           password_confirmation: "password" } }
      }.to change(User, :count).by(0)
      expect(is_logged_in?).not_to be_truthy
    end
  end
end
