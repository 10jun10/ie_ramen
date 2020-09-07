require 'rails_helper'

RSpec.describe Notification, type: :model do
  let!(:notification) { create(:notification) }

  it "notificationインスタンスが有効であること" do
    expect(notification).to be_valid
  end

  it "visitor_idが空だと無効であること" do
    notification.visitor_id = nil
    expect(notification).not_to be_valid
  end

  it "visited_idが空だと無効であること" do
    notification.visited_id = nil
    expect(notification).not_to be_valid
  end

  it "actionが空だと無効であること" do
    notification.action = nil
    expect(notification).not_to be_valid
  end

  it "actionが指定外のものだとだと無効であること" do
    notification.action = "aaaa"
    expect(notification).not_to be_valid
  end

end
