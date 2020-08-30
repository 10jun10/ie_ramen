require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }

  describe "アカウント作成ページ" do
    before do
      visit signup_path
    end

    context "レイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('アカウントの作成')
      end

      it "ログインページへの導線があること" do
        expect(page).to have_link 'ログイン', href: login_path
      end
    end

    context "アカウント作成処理" do
      it "有効な情報でアカウントを作成するとフラッシュが表示されること" do
        fill_in "ユーザー名", with: "test"
        fill_in "メールアドレス", with: "test@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "アカウントを作成する"
        expect(page).to have_content "ご登録ありがとうございます。"
      end

      it "有効な情報でアカウントを作成失敗するとフラッシュが表示されること" do
        fill_in "ユーザー名", with: ""
        fill_in "メールアドレス", with: "test@example.com"
        fill_in "パスワード", with: "password"
        fill_in "パスワード(確認)", with: "password"
        click_button "アカウントを作成する"
        expect(page).to have_content "ユーザー名を入力してください"
        expect(page).to have_content "登録に失敗しました。"
      end
    end
  end

  describe "プロフィール" do
    before do
      visit user_path(user)
    end

    it "正しいタイトルが表示されること" do
      expect(page).to have_title full_title('プロフィール')
    end
  end
end
