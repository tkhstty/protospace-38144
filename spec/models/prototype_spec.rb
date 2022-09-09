require 'rails_helper'

RSpec.describe Prototype, type: :model do
  before do
    @prototype = FactoryBot.build(:prototype)
  end

  describe "プロトタイプ投稿機能" do
    context "投稿出来る時" do
      it "title,catch_copy,concept,imageが存在する場合は投稿できる" do
        expect(@prototype).to be_valid
      end
    end

    context "投稿できない時" do
      it "mp1_プロトタイプの名称が必須である" do
        @prototype.title = ""
        @prototype.valid?
        expect(@prototype.errors.full_messages).to include "Title can't be blank"
      end
      it "mp2_キャッチコピーが必須である" do
        @prototype.catch_copy = ""
        @prototype.valid?
        expect(@prototype.errors.full_messages).to include "Catch copy can't be blank"
      end
      it "mp3_コンセプトの情報が必須である" do
        @prototype.concept = ""
        @prototype.valid?
        expect(@prototype.errors.full_messages).to include "Concept can't be blank"
      end
      it "mp4_画像は1枚必須である" do
        @prototype.image = nil
        @prototype.valid?
        expect(@prototype.errors.full_messages).to include "Image can't be blank"
      end
    end
  end
end
