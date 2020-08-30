require 'rails_helper'

RSpec.describe "Sessions", type: :system do
  let!(:user) { create(:user) }

  before do
    visit login_path
  end

  describe "ログインページ" do
    context "レイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('ログイン')
      end

      it "フォームのラベルが正しく表示されること" do
        expect(page).to have_content "メールアドレス"
        expect(page).to have_content "パスワード"
      end
    
      it "フォームが正しく表示されること" do
        expect(page).to have_css "input#session_email"
        expect(page).to have_css "input#session_password"
      end

      it "ログインボタンが表示される" do
        expect(page).to have_button "ログイン"
      end

      it "アカウント作成ページへの導線があること" do
        expect(page).to have_link 'アカウントを作成する', href: signup_path
      end
    end

    context "ログイン処理" do
      it "ログイン前後でヘッダーが変わること" do 
        expect(page).to have_link "家ラーメンとは", href: about_path
        expect(page).to have_link "アカウント作成", href: signup_path
        expect(page).to have_link "ログイン", href: login_path

        fill_in "メールアドレス", with: user.email
        fill_in "パスワード", with: user.password
        click_button "ログイン"

        expect(page).to have_link "家ラーメンとは", href: about_path
        expect(page).to have_link "プロフィール", href: user_path(user)
        expect(page).to have_link "ログアウト", href: logout_path

      end

      it "無効なアカウントでログインしようとしたときの処理" do
        fill_in "メールアドレス", with: "test@test.com"
        fill_in "パスワード", with: user.password
        click_button "ログイン"

        expect(page).to have_content "入力されたユーザー名やパスワードが正しくありません。確認してからやりなおしてください。"
      end
    end
  end
end
