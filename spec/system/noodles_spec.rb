require 'rails_helper'

RSpec.describe "Noodles", type: :system do
  let!(:user) { create(:user) }
  let!(:noodle) { create(:noodle, user: user) }

  describe "ラーメン一覧ページ" do
    it "正しいタイトルが表示されること" do
      visit root_path
      expect(page).to have_title full_title
    end

    it "ページネーションが表示されること" do
      create_list(:noodle, 20, user: user)
      visit root_path
      expect(page).to have_css ".pagination"
    end

    it "ラーメン投稿用のリンクが表示されること" do
      visit root_path
      expect(page). to have_link "投稿", href: new_noodle_path
    end
  end

  describe "ラーメン投稿ページ" do
    before do
      log_in_as(user)
      visit new_noodle_path
    end

    context "ページレイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title('家ラーメン投稿')
      end

      it "フォームに正しいラベルが表示されること" do
        expect(page).to have_content "商品名"
        expect(page).to have_content "メーカー"
        expect(page).to have_content "購入したお店"
        expect(page).to have_content "おすすめの食べ方"
      end
    end

    context "ラーメン投稿処理" do
      it "有効なデータで投稿すると投稿成功のフラッシュが表示されること" do
        fill_in "商品名", with: "蒙古タンメン"
        fill_in "メーカー", with: "日清食品"
        fill_in "購入したお店", with: "セブンイレブン"
        fill_in "おすすめの食べ方", with: "チーズトッピング"
        click_button "家ラーメンを投稿する"
        expect(page).to have_content "家ラーメンが投稿されました"
      end

      it "無効なデータで投稿すると投稿失敗のフラッシュが表示されること" do
        fill_in "商品名", with: ""
        fill_in "メーカー", with: "日清食品"
        fill_in "購入したお店", with: "セブンイレブン"
        fill_in "おすすめの食べ方", with: "チーズトッピング"
        click_button "家ラーメンを投稿する"
        expect(page).to have_content "投稿に失敗しました"
        expect(page).to have_content "商品名を入力してください"
      end
    end
  end

  describe "詳細ページ" do
    before do
      log_in_as(user)
      visit noodle_path(noodle)
    end

    context "レイアウト" do
      it "正しいタイトルが表示されること" do
        expect(page).to have_title full_title("#{noodle.name}")
      end

      it "正しい情報が表示されること" do
        expect(page).to have_content noodle.name
        expect(page).to have_content noodle.maker
        expect(page).to have_content noodle.eat
        expect(page).to have_content noodle.created_at.strftime("%Y-%m-%d/%H:%M")
        expect(page).to have_content noodle.user.name
        expect(page).to have_content noodle.comments.count
      end

      context "コメント" do
        it "コメントの追加・削除ができること" do
          fill_in "コメント", with: "とても美味しいです"
          click_button "送信"
          expect(page).to have_content "とても美味しいです"
          expect(page).to have_content "コメントを追加しました"
          click_link "delete_comment"
          expect(page).to_not have_content "とても美味しいです"
          expect(page).to have_content "コメントを削除しました"
        end
      end
    end


  end

  describe "編集ページ" do
    before do
      log_in_as(user)
      visit edit_noodle_path(noodle)
      # click_button "編集"
    end

    context "レイアウト" do
      it "フォームに正しいラベルが表示されること" do
        expect(page).to have_content "商品名"
        expect(page).to have_content "メーカー"
        expect(page).to have_content "購入したお店"
        expect(page).to have_content "おすすめの食べ方"
      end
    end

    context "ラーメン投稿処理" do
      it "有効なデータで更新すると更新成功のフラッシュが表示されること" do
        fill_in "商品名", with: "蒙古タンメン"
        fill_in "メーカー", with: "日清食品"
        fill_in "購入したお店", with: "セブンイレブン"
        fill_in "おすすめの食べ方", with: "チーズトッピング"
        click_button "家ラーメンを更新する"
        expect(page).to have_content "家ラーメンが更新されました"
      end

      it "無効なデータで更新すると更新失敗のフラッシュが表示されること" do
        fill_in "商品名", with: ""
        click_button "家ラーメンを更新する"
        expect(page).to have_content "更新に失敗しました"
        expect(page).to have_content "商品名を入力してください"
      end
    end
  end
end
