require 'rails_helper'

RSpec.describe "Notifications", type: :system do
  let!(:user) { create(:user) }
  let!(:other_user) { create(:user) }
  let!(:noodle) { create(:noodle, user: user) }
  let!(:other_noodle) { create(:noodle, user: other_user) }

  context "通知機能" do
    before do
      log_in_as(user)
    end

    context "他ユーザーの投稿に対する処理の場合" do
      before do
        visit noodle_path(other_noodle)
      end

      it "いいねすると通知が行くこと" do
        find('.like').click
        visit noodle_path(other_noodle)
        expect(page).to have_css 'li.no_notification'
        logout
        log_in_as(other_user)
        expect(page).to have_css 'li.on_notification'
        visit notifications_path
        expect(page).to have_css 'li.no_notification'
        expect(page).to have_content "#{user.name}さんが #{other_noodle.name}にいいねしました"
        # expect(page).to have_content other_noodle.name
      end

      it "コメントすると通知が行くこと" do
        fill_in "comment_content", with: "テストコメント"
        click_button "送信"
        expect(page).to have_css 'li.no_notification'
        logout
        log_in_as(other_user)
        expect(page).to have_css 'li.on_notification'
        visit notifications_path
        expect(page).to have_css 'li.no_notification'
        expect(page).to have_content "#{user.name}さんが #{noodle.name}にコメントしました"
      end
    end

    context "自分の投稿に対する処理の場合" do
      before do
        visit noodle_path(noodle)
      end

      it "いいねしても通知が来ないこと" do
        find('.like').click
        visit noodle_path(noodle)
        expect(page).to have_css 'li.no_notification'
        visit notifications_path
        expect(page).to have_content "通知はありません"
      end

      it "コメントしても通知が来ないこと" do
        fill_in "comment_content", with: "テストコメント"
        click_button "送信"
        expect(page).to have_css 'li.no_notification'
        visit notifications_path
        expect(page).to have_content "通知はありません"
      end
    end
  end
end
