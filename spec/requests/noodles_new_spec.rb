require 'rails_helper'

RSpec.describe "ラーメン投稿", type: :request do
  let!(:user) { create(:user) }
  let!(:noodle) { create(:noodle, user: user) }
  let(:image_path) { File.join(Rails.root, 'spec/support/test.jpeg') }
  let(:image) { Rack::Test::UploadedFile.new(image_path) }

  context "ログインしている場合" do
    before do
      get new_noodle_path
      log_in(user)
    end

    it "フレンドリーフォワーディングであること" do
      expect(response).to redirect_to new_noodle_path
    end

    it "有効なデータで投稿できること" do
      expect {
        post noodles_path, params: { noodle: { name: "蒙古タンメン",
                                               maker: "",
                                               place: "セブンイレブン",
                                               taste: "味噌ラーメン",
                                               eat: "チーズのトッピング",
                                               image: image } }
      }      .to change(Noodle, :count).by(1)
      follow_redirect!
      expect(response).to render_template('noodles/show')
    end

    it "無効なデータ(商品名なし)だと投稿できないこと" do
      expect {
        post noodles_path, params: { noodle: { name: "",
                                               maker: "日清食品",
                                               place: "セブンイレブン",
                                               taste: "味噌ラーメン",
                                               eat: "チーズトッピング" } }
      }      .to change(Noodle, :count).by(0)
      expect(response).to render_template("noodles/new")
    end

    it "無効なデータ（味なし）だと投稿できないこと" do
      expect {
        post noodles_path, params: { noodle: { name: "蒙古タンメン",
                                               maker: "日清食品",
                                               place: "セブンイレブン",
                                               taste: "",
                                               eat: "チーズトッピング" } }
      }      .to change(Noodle, :count).by(0)
      expect(response).to render_template("noodles/new")
    end
  end

  context "ログインしていない場合" do
    it "ログイン画面へリダイレクトすること" do
      get new_noodle_path
      expect(response).to have_http_status "302"
      expect(response).to redirect_to login_path
    end
  end
end
