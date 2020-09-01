require 'rails_helper'

RSpec.describe "ラーメン詳細", type: :request do
  let!(:user) { create(:user) }
  let!(:noodle) {create(:noodle, user: user)}

  it "正常なレスポンスを返すこと" do
    get noodle_path(noodle)
    expect(response).to have_http_status "200"
  end
end