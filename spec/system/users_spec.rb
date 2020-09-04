require 'rails_helper'

RSpec.describe "Users", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:admin_user) { create(:user, :admin) }
  let!(:noodle) { create(:noodle, user: user) }

  describe "アカウント一覧ページ" do
    it "ページネーションが適用されていること" do
      create_list(:user, 11)
      log_in_as(admin_user)
      visit users_path
      expect(page).to have_css ".pagination"
      expect(page).to have_content "#{user.name} | 削除"
    end
  end

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
      log_in_as(user)
      create_list(:noodle, 10, user: user)
      visit user_path(user)
    end

    it "正しいタイトルが表示されること" do
      expect(page).to have_title full_title("#{user.name}のプロフィール")
    end

    it "編集ページへの導線が表示されること" do
      expect(page).to have_link "編集", href: edit_user_path(user)
    end

    it "削除のリンクが有ること" do
      expect(page).to have_link "削除"
    end

    context "ラーメンの投稿数が表示されること" do
      it "自分のページの場合" do
        expect(page).to have_content "あなたの食べた家ラーメン(#{user.noodles.count})"
      end

      it "他人のページの場合" do
        visit user_path(other_user)
        expect(page).to have_content "#{other_user.name}さんの食べた家ラーメン(#{other_user.noodles.count})"
      end
    end

    it "ラーメン情報が表示されていること" do
      Noodle.take(10).each do |n|
        expect(page).to have_link n.name
        expect(page).to have_link n.user.name
        expect(page).to have_content n.created_at.strftime("%Y-%m-%d/%H:%M")
      end
    end
  end

  describe "プロフの編集" do
    before do
      log_in_as(user)
      visit user_path(user)
      click_link "編集"
    end

    context "レイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title("プロフィール編集")
      end

      it "有効な情報で更新するとフラッシュが表示されること" do
        fill_in "ユーザー名", with: "test"
        fill_in "メールアドレス", with: "test@example.com"
        fill_in "自己紹介", with: "test"
        click_button "更新する"
        expect(page).to have_content "更新成功しました"
        expect(user.reload.name).to have_content "test"
        expect(user.reload.email).to have_content "test@example.com"
        expect(user.reload.introduction).to have_content "test"
      end

      it "無効な情報で更新するとエラーフラッシュが表示されること" do
        fill_in "ユーザー名", with: ""
        fill_in "メールアドレス", with: ""
        click_button "更新する"
        expect(page).to have_content "更新失敗しました"
        expect(page).to have_content "ユーザー名を入力してください"
        expect(page).to have_content "メールアドレスを入力してください"
        expect(page).to have_content "メールアドレスは不正な値です"
      end
    end
  end

  context "いいね一覧ページ" do
    before do
      log_in_as(user)
    end

    it "正しいタイトルが表示されることを" do
      visit favorites_path
      expect(page).to have_title full_title("いいね")
    end

    it "いいね情報が表示されうこと" do
      visit favorites_path
      expect(page).to have_content "いいね (0)"
      user.favorite(noodle)
      visit favorites_path
      expect(page).to have_content "いいね (1)"
      expect(page).to have_link noodle.name, href: noodle_path(noodle)
      expect(page).to have_content noodle.created_at.strftime("%Y-%m-%d/%H:%M")
      expect(page).to have_link noodle.user.name, href: user_path(noodle.user)
    end
  end

  context "いいね機能の動き" do
    before do
      log_in_as(user)
    end

    it "いいね登録と解除ができること" do
      expect(user.favorite?(noodle)).to be_falsey
      user.favorite(noodle)
      expect(user.favorite?(noodle)).to be_truthy
      user.unfavorite(noodle)
      expect(user.favorite?(noodle)).to be_falsey
    end

    it "トップページでいいねの取り外しができること" do
      visit root_path
      link = find('.like')
      expect(link[:href]).to include "/favorites/#{noodle.id}/create"
      link.click
      link = find('.unlike')
      expect(link[:href]).to include "/favorites/#{noodle.id}/destroy"
      link.click
      link = find('.like')
      expect(link[:href]).to include "/favorites/#{noodle.id}/create"
    end

    it "投稿詳細でいいねの取り外しができること" do
      visit noodle_path(noodle)
      link = find('.like')
      expect(link[:href]).to include "/favorites/#{noodle.id}/create"
      link.click
      link = find('.unlike')
      expect(link[:href]).to include "/favorites/#{noodle.id}/destroy"
      link.click
      link = find('.like')
      expect(link[:href]).to include "/favorites/#{noodle.id}/create"
    end

    it "ユーザー詳細画面でいいねを取り外しができること" do
      visit user_path(user)
      link = find('.like')
      expect(link[:href]).to include "/favorites/#{noodle.id}/create"
      link.click
      link = find('.unlike')
      expect(link[:href]).to include "/favorites/#{noodle.id}/destroy"
      link.click
      link = find('.like')
      expect(link[:href]).to include "/favorites/#{noodle.id}/create"
    end
  end
end
