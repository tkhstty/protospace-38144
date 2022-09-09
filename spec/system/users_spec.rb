require 'rails_helper'

RSpec.describe "Users", type: :system do
  before do
    @user = FactoryBot.build(:user)
  end

  describe "ユーザー新規登録" do
    context "新規登録が出来る時" do
      it "su1_必須項目に適切な値を入力すると、ユーザーの新規登録が出来る" do
        #トップページに移動
        visit root_path
        #トップページに新規登録ボタンがあることを確認
        expect(page).to have_content('新規登録')
        #新規登録ボタンをクリックすると新規登録ページに遷移することを確認
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
        #必須項目を入力
        fill_in 'user[email]', with: @user.email
        fill_in 'user[password]', with: @user.password
        fill_in 'user[password_confirmation]', with: @user.password_confirmation
        fill_in 'user[name]', with: @user.name
        fill_in 'user[profile]', with: @user.profile
        fill_in 'user[occupation]', with: @user.occupation
        fill_in 'user[position]', with: @user.position
        #新規登録ボタンをクリックするとユーザーの新規登録が出来たことを確認
        expect {
          find('input[name="commit"]').click
        }.to change { User.count }.by(1)
        #トップページに遷移したことを確認
        expect(current_path).to eq root_path
      end
    end

    context "ユーザー新規登録が出来ない時" do
      it "su3-1_フォームに適切な値が入力されていない状態では、新規登録できず、そのページに留まる" do
        #トップページに移動
        visit root_path
        #トップページに新規登録ボタンがあることを確認
        expect(page).to have_content('新規登録')
        #新規登録ボタンをクリックすると新規登録ページに遷移することを確認
        click_on '新規登録'
        expect(current_path).to eq new_user_registration_path
        #値を入力せず新規登録ボタンをクリックすると、新規登録できていないことを確認
        expect {
          find('input[name="commit"]').click
        }.to change { User.count }.by(0)
        #新規登録ページにとどまっていることを確認
        expect(current_path).to eq user_registration_path
      end
    end
  end
end


RSpec.describe "Users", type: :system do
  before do
    @user = FactoryBot.create(:user)
  end

  describe "ログイン、ログアウト" do
    context "ログインが出来る時" do
      it "su2_必要な情報を入力すると、ログインができる" do
        #ログイン
        sign_in(@user)
        #ログインし、トップページに遷移していることを確認
        expect(current_path).to eq root_path
        #ログインしたユーザー名がページに表示されていることを確認
        expect(page).to have_content @user.name
      end
    end

    context "ログインが出来ない時" do
      it "su3-2_フォームに適切な値が入力されていない状態では、ログインはできず、そのページに留まる" do
        #ログインページに遷移
        visit new_user_session_path
        #値を入力せずログインボタンをクリックすると、ログイン出来ていないことを確認
        find('input[name="commit"]').click
        expect(page).to have_content 'ユーザーログイン'
        #ログインページに留まっていることを確認
        expect(current_path).to eq user_session_path
      end
    end

    context "ログアウトが出来る時" do
      it "su4_トップページから、ログアウトができる" do
        #ログイン
        sign_in(@user)
        #トップページに遷移していることを確認
        expect(current_path).to eq root_path
        #ログアウトボタンがあることを確認
        expect(page).to have_content 'ログアウト'
        #ログアウトボタンをクリック
        click_on 'ログアウト'
        #ログアウトし、ログインしていたユーザー名が表示されていないことを確認
        expect(page).to have_no_content @user.name
      end
    end

    context "ログアウトしている時" do
      it "su5_ログアウト状態では、ヘッダーに「新規登録」「ログイン」のリンクが存在する" do
        #トップページに遷移
        visit root_path
        #ヘッダーに「新規登録」のリンクが存在することを確認
        expect(find('header')).to have_link '新規登録', href: new_user_registration_path
        #ヘッダーに「ログイン」のリンクが存在することを確認
        expect(find('header')).to have_link 'ログイン', href: new_user_session_path
      end
    end

    context "ログインしている時" do
      it "su6_ログイン状態では、ヘッダーに「ログアウト」「New Proto」のリンクが存在する" do
        #ログイン
        sign_in(@user)
        #トップページに遷移
        visit root_path
        #ヘッダーに「ログアウト」のリンクが存在することを確認
        expect(find('header')).to have_link 'ログアウト', href: destroy_user_session_path
        expect(find('header')).to have_link 'New Proto', href: new_prototype_path
      end
      it "su7_ログイン状態では、トップページに「こんにちは、〇〇さん」とユーザー名が表示されている" do
        #ログイン
        sign_in(@user)
        #トップページに遷移
        visit root_path
        #「こんにちは、〇〇さん」とユーザー名が表示されていることを確認
        expect(page).to have_content "こんにちは、#{@user.name}さん"
      end
    end
  end

  describe "ユーザー詳細ページ機能" do
    #プロトタイプに紐付いたユーザー挙動の確認用にプロトタイプ生成
    before do
      @prototype = FactoryBot.create(:prototype, user: @user)
    end

    context "ログインしている時" do
      it "su8-1_各ページのユーザー名をクリックすると、ユーザーの詳細ページへ遷移する" do
        #ログイン
        sign_in(@user)
        #トップページのユーザー名をクリックすると、ユーザー詳細ページへ遷移することを確認
        visit root_path
        click_on @user.name
        expect(current_path).to eq user_path(@user)
        #プロトタイプ詳細ページのユーザー名をクリックすると、ユーザー詳細ページへ遷移することを確認
        visit prototype_path(@prototype)
        click_on @user.name
        expect(current_path).to eq user_path(@user)
      end
      it "su9-1_ユーザーの詳細ページには、そのユーザーの詳細情報（名前・プロフィール・所属・役職）と、そのユーザーが投稿したプロトタイプが表示されている" do
        #ログイン
        sign_in(@user)
        #ユーザー詳細ページへ遷移
        visit user_path(@user)
        #ユーザーの詳細情報が表示されていることを確認
        expect(page).to have_content @user.name
        expect(page).to have_content @user.profile
        expect(page).to have_content @user.occupation
        expect(page).to have_content @user.position
        #ユーザーが投稿したプロトタイプが表示されていることを確認
        expect(page).to have_content @prototype.title
        expect(page).to have_content @prototype.catch_copy
        expect(find('.card__img')[:src]).to match /.*test_image1.png/
      end
    end

    context "ログアウトしている時" do
      it "su8-2_各ページのユーザー名をクリックすると、ユーザーの詳細ページへ遷移する" do
        #トップページのユーザー名をクリックすると、ユーザー詳細ページへ遷移することを確認
        visit root_path
        click_on @user.name
        expect(current_path).to eq user_path(@user) 
        #プロトタイプ詳細ページのユーザー名をクリックすると、ユーザー詳細ページへ遷移することを確認
        visit prototype_path(@prototype)
        click_on @user.name
        expect(current_path).to eq user_path(@user)
      end
      it "su9-2_ユーザーの詳細ページには、そのユーザーの詳細情報（名前・プロフィール・所属・役職）と、そのユーザーが投稿したプロトタイプが表示されている" do
        #ユーザー詳細ページへ遷移
        visit user_path(@user)
        #ユーザーの詳細情報が表示されていることを確認
        expect(page).to have_content @user.name
        expect(page).to have_content @user.profile
        expect(page).to have_content @user.occupation
        expect(page).to have_content @user.position
        #ユーザーが投稿したプロトタイプが表示されていることを確認
        expect(page).to have_content @prototype.title
        expect(page).to have_content @prototype.catch_copy
        expect(find('.card__img')[:src]).to match /.*test_image1.png/
      end
    end
  end
end
