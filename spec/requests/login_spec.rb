require 'rails_helper'

RSpec.describe "Sessions", type: :request do
  let!(:user) { create(:user) }

  describe "ログイン" do
    it "正常なレスポンスを返すこと" do
      get login_path
      expect(response).to have_http_status(:success)
      expect(response).to have_http_status "200"
    end

    it "有効なアカウントでログイン・ログアウトすること" do
      get login_path
      post login_path, params: { session: { email: user.email,
                                            password: user.password } }
      redirect_to user
      follow_redirect!
      expect(response).to render_template('users/show')
      expect(is_logged_in?).to be_truthy
      delete logout_path
      expect(is_logged_in?).not_to be_truthy
      redirect_to root_path
    end

    it "ログイン後ログイン画面へいけないこと" do
      log_in(user)
      get login_path
      expect(response).to have_http_status(302)
    end

    it "無効なアカウントでログインすること" do
      get login_path
      post login_path, params: { session: { email: "test@test.com",
                                            password: user.password } }
      expect(is_logged_in?).not_to be_truthy
    end
  end
end
