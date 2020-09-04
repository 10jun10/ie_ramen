require 'rails_helper'

RSpec.describe Comment, type: :model do
  let(:comment) { create(:comment) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(comment).to be_valid
    end

    it "user_idが空だと無効であること" do
      comment.user_id = nil
      expect(comment).not_to be_valid
    end

    it "noodle_idが空だと無効であること" do
      comment.noodle_id = nil
      expect(comment).not_to be_valid
    end

    it "コメント内容がなければ無効であること" do
      comment.content = nil
      expect(comment).not_to be_valid
    end

    it "コメントが100字を超えるとエラーメッセージが表示されることこと" do
      comment.content = "a" * 101
      comment.valid?
      expect(comment.errors[:content]).to include("は100文字以内で入力してください")
    end
  end
end
