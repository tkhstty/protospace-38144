require 'rails_helper'

RSpec.describe User, type: :model do
  before do
    @user = FactoryBot.build(:user)
  end

  describe "ユーザー新規登録" do
    context "新規登録ができる時" do
      it "email,password,name,profile,occupation,positionがあれば登録ができる" do
        expect(@user).to be_valid
      end
    end
    context "新規登録ができない時" do
      it "mu1_メールアドレスが必須である" do
        @user.email = ""
        @user.valid?
        expect(@user.errors.full_messages).to include "Email can't be blank"
      end
      it "mu2_メールアドレスは一意性である" do
        @user.save
        email_test_user = FactoryBot.build(:user, email: @user.email)
        email_test_user.valid?
        expect(email_test_user.errors.full_messages).to include "Email has already been taken"
      end
      it "mu3_メールアドレスは@を含む必要がある" do
        @user.email = "test_email"
        @user.valid?
        expect(@user.errors.full_messages).to include "Email is invalid"
      end
      it "mu4_パスワードが必須である" do
        @user.password = ""
        @user.valid?
        expect(@user.errors.full_messages).to include "Password can't be blank"
      end
      it "mu5_パスワードは6文字以上である" do
        @user.password = "12345"
        @user.password_confirmation = @user.password
        @user.valid?
        expect(@user.errors.full_messages).to include "Password is too short (minimum is 6 characters)"
      end
      it "mu6_パスワードは確認用を含めて2回入力する" do
        @user.password_confirmation = ""
        @user.valid?
        expect(@user.errors.full_messages).to include "Password confirmation doesn't match Password"
      end
      it "mu7_パスワードとパスワード確認用の値の一致が必須である" do
        @user.password = "123456"
        @user.password_confirmation = "1234567"
        @user.valid?
        expect(@user.errors.full_messages).to include "Password confirmation doesn't match Password"
      end
      it "mu8_ユーザー名が必須である" do
        @user.name = ""
        @user.valid?
        expect(@user.errors.full_messages).to include "Name can't be blank"
      end
      it "mu9_プロフィールが必須である" do
        @user.profile = ""
        @user.valid?
        expect(@user.errors.full_messages).to include "Profile can't be blank"
      end
      it "mu10_所属が必須である" do
        @user.occupation = ""
        @user.valid?
        expect(@user.errors.full_messages).to include "Occupation can't be blank"
      end
      it "mu11_役職が必須である" do
        @user.position = ""
        @user.valid?
        expect(@user.errors.full_messages).to include "Position can't be blank"
      end
    end
  end
end
