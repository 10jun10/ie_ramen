require 'rails_helper'

RSpec.describe Favorite, type: :model do
  let!(:favorite) { create(:favorite) }
  
  it "インスタンスが有効であること" do
    expect(favorite).to be_valid
  end

  it "user_idがないと無効であること" do
    favorite.user_id = nil
    expect(favorite).not_to be_valid
  end

  it "noodle_idがないと無効であること" do
    favorite.noodle_id = nil
    expect(favorite).not_to be_valid
  end

end
