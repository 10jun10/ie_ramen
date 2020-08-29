require 'rails_helper'

RSpec.describe User, type: :model do
  let(:user) { create(:user) }

  describe "ユーザー登録できる場合" do
    it "新規登録できること" do
      expect(user).to be_valid
    end
  end

  describe "ユーザー名を検証する場合" do
    it "ユーザー名がないと無効であること" do
      user.name = nil
      user.valid?
      expect(user.errors[:name]).to include("を入力してください")
    end

    it "ユーザー名が50字以内で有効であること" do
      user.name = "a" * 50
      user.valid?
      expect(user).to be_valid
    end

    it "ユーザー名が51字以上で無効であること" do
      user.name = "a" * 51
      user.valid?
      expect(user.errors[:name]).to include("は50文字以内で入力してください")
    end
  end

  describe "メールアドレスを検証する場合" do
    it "メールアドレスがないと無効であること" do
      user.email = nil
      user.valid?
      expect(user.errors[:email]).to include("を入力してください")
    end

    it '重複したメールアドレスなら無効な状態であること' do
      FactoryBot.create(:user, email: 'test@example.jp')
      user.email = 'test@example.jp'
      user.valid?
      expect(user.errors[:email]).to include('はすでに存在します')
    end

    it "メールアドレスが小文字で保存されること" do
      user.email = "TEST@example.com"
      user.save
      expect(user.email).to eq "test@example.com"
    end
  end

  describe "パスワードを検証する場合" do
    it "パスワードがないと無効であること" do
      user.password = nil
      user.valid?
      expect(user.errors[:password]).to include("を入力してください")
    end

    it "パスワードが6文字未満だと無効であること" do
      user.password = "a" * 5
      user.valid?
      expect(user.errors[:password]).to include("は6文字以上で入力してください")
    end

    it "パスワードが確認用パスワードと不一致だと無効であること" do
      user.password = "a" * 6
      user.password_confirmation = "b" * 6
      user.valid?
      expect(user.errors[:password_confirmation]).to include("とパスワードの入力が一致しません")
    end
  end
end
