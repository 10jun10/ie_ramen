require 'rails_helper'

RSpec.describe "ラーメン削除", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:noodle) { create(:noodle, user: user) }

  context "ログインしているユーザーが自身の投稿を削除する場合" do
    it "投稿が削除されリダイレクトされること" do
      log_in(user)
      expect {
        delete noodle_path(noodle)
      }      .to change(Noodle, :count).by(-1)
      expect(response).to redirect_to root_path
    end
  end

  context "ログインしているユーザーが違うユーザーの投稿を削除する場合" do
    it "投稿は削除されず投稿一覧ページにリダイレクトされること" do
      log_in(other_user)
      expect {
        delete noodle_path(noodle)
      }      .to change(Noodle, :count).by(0)
      expect(response).to redirect_to root_path
    end
  end

  context "ログインしていないユーザーが違うユーザーん投稿を削除する場合" do
    it "ログイン画面へリダイレクトされること" do
      expect {
        delete noodle_path(noodle)
      }      .to change(Noodle, :count).by(0)
      expect(response).to redirect_to login_path
    end
  end
end
