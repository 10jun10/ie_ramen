require 'rails_helper'

RSpec.describe Noodle, type: :model do
  let!(:noodle) { create(:noodle) }

  context "バリデーション" do
    it "有効な状態であること" do
      expect(noodle).to be_valid
    end

    it "商品名がないと無効であること" do
      noodle.name = nil
      noodle.valid?
      expect(noodle.errors[:name]).to include("を入力してください")
    end

    it "商品名が51字以上で無効あること" do
      noodle.name = "a" * 51
      noodle.valid?
      expect(noodle.errors[:name]).to include("は50文字以内で入力してください")
    end

    it "商品名が50字以下で有効あること" do
      noodle.name = "a" * 50
      noodle.valid?
      expect(noodle).to be_valid
    end

    it "メーカーが30字以上で無効あること" do
      noodle.maker = "a" * 31
      noodle.valid?
      expect(noodle.errors[:maker]).to include("は30文字以内で入力してください")
    end
    it "メーカーが30字以下で有効あること" do
      noodle.maker = "a" * 30
      noodle.valid?
      expect(noodle).to be_valid
    end

    it "購入した店が31字以上で無効あること" do
      noodle.place = "a" * 31
      noodle.valid?
      expect(noodle.errors[:place]).to include("は30文字以内で入力してください")
    end

    it "購入した店が30字以下で有効あること" do
      noodle.place = "a" * 30
      noodle.valid?
      expect(noodle).to be_valid
    end

    it "おすすめの食べ方が201字以上で無効あること" do
      noodle.eat = "a" * 201
      noodle.valid?
      expect(noodle.errors[:eat]).to include("は200文字以内で入力してください")
    end

    it "おすすめの食べ方が200字以下で有効あること" do
      noodle.eat = "a" * 200
      noodle.valid?
      expect(noodle).to be_valid
    end
  end
end
