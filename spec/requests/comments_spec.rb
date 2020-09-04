require 'rails_helper'

RSpec.describe "コメント", type: :request do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:noodle) { create(:noodle) }
  let!(:comment) { create(:comment, user_id: user.id, noodle: noodle) }

  context "コメント投稿" do
    context "ログインしている場合" do
      before do
        log_in(user)
      end

      it "有効な内容でコメントできること" do
        expect {
          post comments_path, params: { noodle_id: noodle.id,
                                        comment: { content: "美味しいです" } }
        }.to change(noodle.comments, :count).by(1)
      end

      it "コメントが空だと投稿できないこと" do
        expect {
          post comments_path, params: { noodle_id: noodle.id,
                                        comment: { content: "" } }
        }.not_to change(noodle.comments, :count)
      end
    end

    context "ログインしていない場合" do
      it "投稿失敗し、ログイン画面にリダイレクトすること" do
        expect {
          post comments_path, params: { noodle_id: noodle.id,
                                        comment: { content: "美味しいです" } }
        }.not_to change(noodle.comments, :count)
      expect(response).to redirect_to login_path
      end
    end
  end

  context "コメント削除" do
    context "ログインしている場合" do
      context "コメントしたユーザーがログインしている場合" do
        it "投稿を削除できること" do
          log_in(user)
          expect {
              delete comment_path(comment)
          }.to change(noodle.comments, :count).by(-1)
        end
      end

      context "コメントしたユーザーでないユーザーがログインしている場合" do
        it "投稿を削除できること" do
          log_in(other_user)
          expect {
              delete comment_path(comment)
          }.not_to change(noodle.comments, :count)
        end
      end
    end

    context "ログインしていない場合" do
      it "削除失敗し、ログイン画面にリダイレクトすること" do
        expect {
          delete comment_path(comment)
        }.not_to change(noodle.comments, :count)
      expect(response).to redirect_to login_path
      end
    end
  end
end
