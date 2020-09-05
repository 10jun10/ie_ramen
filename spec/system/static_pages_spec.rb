require 'rails_helper'

RSpec.describe "静的ページ", type: :system do
  let!(:user) { create(:user) }
  let!(:noodle) { create(:noodle, user: user) }

  describe "トップ" do
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

  describe "アプリについて" do
    before do
      visit about_path
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('家ラーメンとは')
    end
  end
end
