require 'rails_helper'

RSpec.describe "静的ページ", type: :system do
  describe "アプリについて" do
    before do
      visit about_path
    end

    it "正しいタイトルが表示されることを確認" do
      expect(page).to have_title full_title('家ラーメンとは')
    end

  end
end
