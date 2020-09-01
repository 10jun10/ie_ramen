require 'rails_helper'

RSpec.describe "ラーメン編集", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:noodle) {create(:noodle, user: user)}

  context "許可されたユーザーの場合" do
    it "正常な更新されること" do
      get edit_noodle_path(noodle)
      log_in(user)
      # expect(response).to render_template("noodles/edit")
      expect(response).to redirect_to edit_noodle_path(noodle)
      patch noodle_path(noodle), params: { noodle: {name: "どん兵衛",
                                                    maker: "日清食品",
                                                    place: "西友",
                                                    eat: "３分で食べる" } }
      redirect_to noodle
      follow_redirect!
      expect(response).to render_template('noodles/show')
    end
  end

  context "許可されていないユーザーの場合" do
    context "他のユーザーの場合" do
      it "投稿一覧画面にリダイレクトされること" do
        log_in(other_user)
        get edit_noodle_path(noodle)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path

        patch noodle_path(noodle), params: { noodle: {name: "どん兵衛",
                                                      maker: "日清食品",
                                                      place: "西友",
                                                      eat: "３分で食べる" } }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to root_path
      end
    end

    context "ログインしていないユーザーの場合" do
      it "ログイン画面へリダイレクトされること" do
        get edit_noodle_path(noodle)
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
  
        patch noodle_path(noodle), params: { noodle: {name: "どん兵衛",
                                                      maker: "日清食品",
                                                      place: "西友",
                                                      eat: "３分で食べる" } }
        expect(response).to have_http_status "302"
        expect(response).to redirect_to login_path
      end
    end
  end

end