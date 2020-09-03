require 'rails_helper'

RSpec.describe "いいね機能", type: :request do
  let!(:user) { create(:user) }
  let!(:noodle) { create(:noodle) }

  context "いいねの処理" do
    context "ログインしている場合" do
      before do
        log_in(user)
      end

      it "いいねができること" do
        expect {
          post "/favorites/#{noodle.id}/create"
               }.to change(Favorite, :count).by(1)
      end
      it "いいねができることajax" do
        expect {
          post "/favorites/#{noodle.id}/create", xhr: true
               }.to change(Favorite, :count).by(1)
      end

      it "いいね解除ができること" do
        user.favorite(noodle)
        expect {
          delete "/favorites/#{noodle.id}/destroy", xhr: true
               }.to change(Favorite, :count).by(-1)
      end
      it "いいね解除ができることajax" do
        user.favorite(noodle)
        expect {
          delete "/favorites/#{noodle.id}/destroy"
               }.to change(Favorite, :count).by(-1)
      end
    end

    context "ログインしていない場合" do
      it "いいねできずにリダイレクトされること" do
        expect {
          post "/favorites/#{noodle.id}/create"
               }.not_to change(Favorite, :count)
        expect(response).to redirect_to login_path
      end

      it "いいね解除できずにリダイレクトされること" do
        expect {
          delete "/favorites/#{noodle.id}/destroy"
               }.not_to change(Favorite, :count)
          expect(response).to redirect_to login_path
      end
    end
  end

  context "一覧ページ" do
    context "ログインしている場合" do
      it "正常なレスポンスを返すこと" do
        log_in(user)
        get favorites_path
        expect(response).to have_http_status "200"
        expect(response).to render_template('favorites/index')
      end
    end

    context "ログインしていない場合" do
      it "ログイン画面へリダイレクトすること" do
        get favorites_path
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end
  end
end
