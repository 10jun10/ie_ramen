require "rails_helper"

RSpec.describe "ユーザーの削除", type: :request do
  let!(:admin_user) { create(:user, :admin) }
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }

  context "管理者の場合" do
    it "管理者が他のを削除できること" do
      log_in(admin_user)
      expect { delete user_path(user) }.to change(User, :count).by(-1)
      redirect_to users_path
      follow_redirect!
      expect(response).to render_template('users/index')
    end
  end

  context "管理者以外の場合" do
    it "自身のアカウントを削除できること" do
      log_in(user)
      expect { delete user_path(user) }.to change(User, :count).by(-1)
      redirect_to root_path
    end

    it "他のアカウントを削除しようとするとリダイレクトすること" do
      log_in(user)
      expect { delete user_path(other_user) }.not_to change(User, :count)
      expect(response).to have_http_status "302"
      expect(response).to redirect_to root_path
    end
  end
end
