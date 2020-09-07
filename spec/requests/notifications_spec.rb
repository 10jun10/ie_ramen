require 'rails_helper'

RSpec.describe "通知機能", type: :request do
  let!(:user) { create(:user) }

  describe "通知一覧" do
    context "ログインしている場合" do
      before do
        log_in(user)
      end

      it "正常なレスポンスを返すこと" do
        get notifications_path
        expect(response).to have_http_status(:success)
      end
    end

    context "ログインしていない場合" do
      it "ログイン画面へリダイレクトすること" do
        get notifications_path
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end
  end
end
