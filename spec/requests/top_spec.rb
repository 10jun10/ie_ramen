require 'rails_helper'

RSpec.describe "ラーメン一覧", type: :request do
  let!(:user) { create(:user) }
  let!(:noodle) { create(:noodle, user: user) }
  let!(:noodle_yesterday) { create(:noodle, :yesterday) }
  let!(:noodle_two_days_ago) { create(:noodle, :two_days_ago) }
  let!(:noodle_three_days_ago) { create(:noodle, :three_days_ago) }

  context "投稿の並び" do
    it "降順であること" do
      expect(noodle).to eq Noodle.first
    end
  end
end
