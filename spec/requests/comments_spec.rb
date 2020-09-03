require 'rails_helper'

RSpec.describe "コメント", type: :request do
  let!(:user) { create(:user)}
  let!(:noodle) { create(:noodle)}
  let!(:comment) { create(:comment, user_id: user.id, noodle: noodle)}

  context "コメント投稿" do
    context "ログインしている場合" do
      it "" do
      end
    end

    context "ログインしていない場合" do
      it "投稿失敗し、ログイン画面にリダイレクトすること" do
        expect {
          post comments_path, params: { noodle_id: noodle.id,
                                        comment: { content: "美味しいです" } }
      }.to_not change(noodle.comments, :count)
      expect(response).to redirect_to login_path
      end
    end
  end

  context "コメント削除" do
    context "ログインしている場合" do
      it "" do
      end
    end

    context "ログインしていない場合" do
      it "削除失敗し、ログイン画面にリダイレクトすること" do
        expect {
          delete comment_path(comment)
      }.to_not change(noodle.comments, :count)
      expect(response).to redirect_to login_path
      end
    end
  end
end 
