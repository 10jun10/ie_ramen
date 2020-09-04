require 'rails_helper'

RSpec.describe "ラーメン詳細", type: :request do
  let!(:user) { create(:user) }
  let!(:noodle) { create(:noodle, user: user) }

  context "ログインしている場合" do
    it "正常なレスポンスを返すこと" do
      log_in(user)
      get noodle_path(noodle)
      expect(response).to have_http_status "200"
    end
  end

  context "ログインしていない場合場合" do
    it "ログイン画面へリダイレクトすること" do
      get noodle_path(noodle)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
