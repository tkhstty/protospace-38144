require 'rails_helper'

RSpec.describe "Prototypes", type: :system do
  before do
    @prototype = FactoryBot.build(:prototype)
    @prototype.user.save
  end

  describe "プロトタイプ投稿機能" do
    it "sp1_ログイン状態のユーザーだけが、投稿ページへ遷移できる" do
      #投稿ページへ遷移
      visit new_prototype_path
      #ログインしていないため、ログインページへリダイレクトされることを確認
      expect(current_path).to eq new_user_session_path
      #ログイン
      sign_in(@prototype.user)
      #投稿ページへ遷移
      visit new_prototype_path
      #投稿ページへ遷移していることを確認
      expect(current_path).to eq new_prototype_path
    end
    it "sp2_投稿に必要な情報が入力されていない場合は、投稿できずにそのページに留まる" do
      #ログイン
      sign_in(@prototype.user)
      #投稿ページへ遷移
      visit new_prototype_path
      #必要な情報を入力せずに、投稿ボタンをクリックするとPrototypeカウントが増えていないことを確認
      expect {
        find('input[name="commit"]').click
      }.to change { Prototype.count }.by(0)
      #そのページに留まっていることを確認
      expect(current_path).to eq prototypes_path
    end
    it "sp3_バリデーションによって投稿ができず、そのページに留まった場合でも、入力済みの項目（画像以外）は消えない" do
      #ログイン
      sign_in(@prototype.user)
      #投稿ページへ遷移
      visit new_prototype_path
      #画像以外を入力
      fill_in 'prototype[title]', with: @prototype.title
      fill_in 'prototype[catch_copy]', with: @prototype.catch_copy
      fill_in 'prototype[concept]', with: @prototype.concept
      #投稿ボタンをクリック
      find('input[name="commit"]').click
      #そのページに留まっていることを確認
      expect(current_path).to eq prototypes_path
      #画像以外の項目が消えていないことを確認
      expect(find('#prototype_title').value).to eq @prototype.title
      expect(find('#prototype_catch_copy').text).to eq @prototype.catch_copy
      expect(find('#prototype_concept').text).to eq @prototype.concept
    end
    it "sp4_必要な情報を入力すると、投稿ができる" do
      #ログイン
      sign_in(@prototype.user)
      #投稿ページへ遷移
      visit new_prototype_path
      #必要な情報を入力
      fill_in 'prototype[title]', with: @prototype.title
      fill_in 'prototype[catch_copy]', with: @prototype.catch_copy
      fill_in 'prototype[concept]', with: @prototype.concept
      image_path = Rails.root.join('public/images/test_image1.png')
      attach_file 'prototype[image]', image_path, make_visible: true
      #投稿ボタンをクリックすると、Prototypeカウントが増えていることを確認
      expect {
        find('input[name="commit"]').click
      }.to change { Prototype.count }.by(1)
    end
    it "sp5_正しく投稿できた場合は、トップページへ遷移する" do
      #ログイン
      sign_in(@prototype.user)
      #投稿ページへ遷移
      visit new_prototype_path
      #必要な情報を入力
      fill_in 'prototype[title]', with: @prototype.title
      fill_in 'prototype[catch_copy]', with: @prototype.catch_copy
      fill_in 'prototype[concept]', with: @prototype.concept
      image_path = Rails.root.join('public/images/test_image1.png')
      attach_file 'prototype[image]', image_path, make_visible: true
      #投稿ボタンをクリック
      find('input[name="commit"]').click
      #トップページへ遷移していることを確認
      expect(current_path).to eq root_path
    end
    it "sp6_投稿した情報は、トップページに表示される" do
      #ログイン
      sign_in(@prototype.user)
      #投稿ページへ遷移
      visit new_prototype_path
      #必要な情報を入力
      fill_in 'prototype[title]', with: @prototype.title
      fill_in 'prototype[catch_copy]', with: @prototype.catch_copy
      fill_in 'prototype[concept]', with: @prototype.concept
      image_path = Rails.root.join('public/images/test_image1.png')
      attach_file 'prototype[image]', image_path, make_visible: true
      #投稿ボタンをクリック
      find('input[name="commit"]').click
      #トップページへ遷移していることを確認
      expect(current_path).to eq root_path
      #投稿した情報が表示されていることを確認
      expect(page).to have_content @prototype.title
      expect(page).to have_content @prototype.catch_copy
      expect(all('.card__img')[0][:src]).to match /.*test_image1.png/
    end
    it "sp7_トップページに表示される投稿情報は、プロトタイプ毎に、画像・プロトタイプ名・キャッチコピー・投稿者の名前の、4つの情報について表示できる" do
      #ログイン
      sign_in(@prototype.user)
      #投稿ページへ遷移
      visit new_prototype_path
      #必要な情報を入力
      fill_in 'prototype[title]', with: @prototype.title
      fill_in 'prototype[catch_copy]', with: @prototype.catch_copy
      fill_in 'prototype[concept]', with: @prototype.concept
      image_path = Rails.root.join('public/images/test_image1.png')
      attach_file 'prototype[image]', image_path, make_visible: true
      #投稿ボタンをクリック
      find('input[name="commit"]').click
      #トップページへ遷移していることを確認
      expect(current_path).to eq root_path
      #画像・プロトタイプ名・キャッチコピー・投稿者の名前が表示されていることを確認
      expect(page).to have_content @prototype.title
      expect(page).to have_content @prototype.catch_copy
      expect(all('.card__img')[0][:src]).to match /.*test_image1.png/
      expect(page).to have_content @prototype.user.name
    end
    it "sp8_画像が表示されており、画像がリンク切れなどになっていない" do
      #ログイン
      sign_in(@prototype.user)
      #投稿ページへ遷移
      visit new_prototype_path
      #必要な情報を入力
      fill_in 'prototype[title]', with: @prototype.title
      fill_in 'prototype[catch_copy]', with: @prototype.catch_copy
      fill_in 'prototype[concept]', with: @prototype.concept
      image_path = Rails.root.join('public/images/test_image1.png')
      attach_file 'prototype[image]', image_path, make_visible: true
      #投稿ボタンをクリック
      find('input[name="commit"]').click
      #トップページへ遷移していることを確認
      expect(current_path).to eq root_path
      #画像が表示されており、画像がリンク切れになっていないか確認
      expect(all('.card__img')[0][:src]).not_to be_nil
    end
  end
end


RSpec.describe "Prototypes", type: :system do
  before do
    @prototype = FactoryBot.create(:prototype)
    @another_user = FactoryBot.create(:user)
  end

  describe "プロトタイプ詳細ページ機能" do
    context "ログインしている時" do
      it "sp9-1_一覧表示されている画像をクリックすると、該当するプロトタイプの詳細ページへ遷移する" do
        #ログイン
        sign_in(@prototype.user)
        #トップページに遷移
        visit root_path
        #一覧表示されている画像をクリック
        all('.card__img')[0].click
        #該当するプロトタイプの詳細ページへ遷移していることを確認
        expect(current_path).to eq prototype_path(@prototype)
      end
      it "sp9-2_一覧表示されているプロトタイプ名をクリックすると、該当するプロトタイプの詳細ページへ遷移する" do
        #ログイン
        sign_in(@prototype.user)
        #トップページに遷移
        visit root_path
        #一覧表示されているプロトタイプ名をクリック
        find_link(@prototype.title).click 
        #該当するプロトタイプの詳細ページへ遷移していることを確認
        expect(current_path).to eq prototype_path(@prototype)
      end
      it "sp10-1_ログイン状態の投稿したユーザーだけに、「編集」「削除」のリンクが存在する" do
        #ログイン
        sign_in(@prototype.user)
        #プロトタイプの詳細ページに遷移
        visit prototype_path(@prototype)
        #「編集」のリンクが存在することを確認
        expect(page).to have_link '編集', href: edit_prototype_path(@prototype)
        #「削除」のリンクが存在することを確認
        expect(page).to have_link '削除', href: prototype_path(@prototype)
      end
      it "sp11-1_プロダクトの情報（プロトタイプ名・投稿者・画像・キャッチコピー・コンセプト）が表示されている" do
        #ログイン
        sign_in(@prototype.user)
        #プロトタイプの詳細ページに遷移
        visit prototype_path(@prototype)
        #プロダクトの情報が表示されていることを確認
        expect(page).to have_content @prototype.title
        expect(page).to have_content @prototype.user.name
        expect(find('.prototype__image').find('img')[:src]).to match /.*test_image1.png/
        expect(page).to have_content @prototype.catch_copy
        expect(page).to have_content @prototype.concept
      end
      it "sp12-1_画像が表示されており、画像がリンク切れなどになっていない" do
        #ログイン
        sign_in(@prototype.user)
        #プロトタイプの詳細ページに遷移
        visit prototype_path(@prototype)
        #画像が表示されており、画像がリンク切れなどになっていないことを確認
        expect(find('.prototype__image').find('img')[:src]).not_to be_nil
      end
    end

    context "ログアウトしている時" do
      it "sp9-3_一覧表示されている画像をクリックすると、該当するプロトタイプの詳細ページへ遷移する" do
        #トップページに遷移
        visit root_path
        #一覧表示されている画像をクリック
        all('.card__img')[0].click
        #該当するプロトタイプの詳細ページへ遷移していることを確認
        expect(current_path).to eq prototype_path(@prototype)
      end
      it "sp9-4_一覧表示されているプロトタイプ名をクリックすると、該当するプロトタイプの詳細ページへ遷移する" do
        #トップページに遷移
        visit root_path
        #一覧表示されているプロトタイプ名をクリック
        find_link(@prototype.title).click 
        #該当するプロトタイプの詳細ページへ遷移していることを確認
        expect(current_path).to eq prototype_path(@prototype)
      end
      it "sp10-2_ログアウト状態では、「編集」「削除」のリンクが存在しない" do
        #プロトタイプの詳細ページに遷移
        visit prototype_path(@prototype)
        #「編集」のリンクが存在することを確認する
        expect(page).to have_no_link '編集', href: edit_prototype_path(@prototype)
        #「削除」のリンクが存在することを確認する
        expect(page).to have_no_link '削除', href: prototype_path(@prototype)
      end
      it "sp11-2_プロダクトの情報（プロトタイプ名・投稿者・画像・キャッチコピー・コンセプト）が表示されている" do
        #プロトタイプの詳細ページに遷移
        visit prototype_path(@prototype)
        #プロダクトの情報が表示されていることを確認
        expect(page).to have_content @prototype.title
        expect(page).to have_content @prototype.user.name
        expect(find('.prototype__image').find('img')[:src]).to match /.*test_image1.png/
        expect(page).to have_content @prototype.catch_copy
        expect(page).to have_content @prototype.concept
      end
      it "sp12-2_画像が表示されており、画像がリンク切れなどになっていない" do
        #プロトタイプの詳細ページに遷移
        visit prototype_path(@prototype)
        #画像が表示されており、画像がリンク切れなどになっていないことを確認
        expect(find('.prototype__image').find('img')[:src]).not_to be_nil
      end
    end
  end

  describe "プロトタイプ編集機能" do
    before do
      #編集用のデータを生成
      @edit_prototype = FactoryBot.build(:prototype, user: @prototype.user)
    end

    it "sp13_投稿に必要な情報を入力すると、プロトタイプが編集できる" do
      #ログイン
      sign_in(@prototype.user)
      #プロトタイプの編集ページへ遷移
      visit edit_prototype_path(@prototype)
      #投稿に必要な情報を入力
      fill_in 'prototype[title]', with: @edit_prototype.title
      fill_in 'prototype[catch_copy]', with: @edit_prototype.catch_copy
      fill_in 'prototype[concept]', with: @edit_prototype.concept
      image_path = Rails.root.join('public/images/test_image2.jpg')
      attach_file 'prototype[image]', image_path, make_visible: true
      #プロトタイプが編集されてもPrototypeモデルのカウントが変わっていないことを確認
      expect {
        find('input[name="commit"]').click
      }.to change{ Prototype.count }.by(0)
      #詳細ページに遷移していることを確認
      expect(current_path).to eq prototype_path(@prototype)
      #編集した情報が表示されていることを確認
      expect(page).to have_content @edit_prototype.title
      expect(page).to have_content @edit_prototype.catch_copy
      expect(page).to have_content @edit_prototype.concept
      expect(find('.prototype__image').find('img')[:src]).to match /.*test_image2.jpg/
    end
    it "sp14_何も編集せずに更新をしても、画像無しのプロトタイプにならない" do
      #ログイン
      sign_in(@prototype.user)
      #プロトタイプの編集ページへ遷移
      visit edit_prototype_path(@prototype)
      #何も編集せずに更新
      find('input[name="commit"]').click
      #画像なしのプロトタイプになっていないことを確認
      expect(find('.prototype__image').find('img')[:src]).not_to be_nil
    end
    it "sp15-1_ログイン状態のユーザーでなければ、投稿されたプロトタイプの詳細ページから編集ボタンをクリックして、編集ページへ遷移できないことを確認" do
      #プロトタイプの詳細ページへ遷移
      visit prototype_path(@prototype)
      #編集ボタンがないことを確認
      expect(page).to have_no_link '編集する', href: edit_prototype_path(@prototype)
    end
    it "sp15-2_ログイン状態のユーザーであれば、自身の投稿したプロトタイプの詳細ページから編集ボタンをクリックすると、編集ページへ遷移できることを確認" do
      #ログイン
      sign_in(@prototype.user)
      #プロトタイプの詳細ページへ遷移
      visit prototype_path(@prototype)
      #編集ボタンをクリック
      click_on '編集する'
      #編集ページへ遷移できることを確認
      expect(current_path).to eq edit_prototype_path(@prototype)
    end
    it "sp16_プロトタイプ情報について、すでに登録されている情報は、編集画面を開いた時点で表示される" do
      #ログイン
      sign_in(@prototype.user)
      #プロトタイプの編集ページへ遷移
      visit edit_prototype_path(@prototype)
      #すでに登録されている情報は、編集画面を開いた時点で表示されることを確認
      expect(find('#prototype_title').value).to eq @prototype.title
      expect(find('#prototype_catch_copy').text).to eq @prototype.catch_copy
      expect(find('#prototype_concept').text).to eq @prototype.concept
    end
    it "sp17_空の入力欄がある場合は、編集できずにそのページに留まる" do
      #ログイン
      sign_in(@prototype.user)
      #編集ページに遷移
      visit edit_prototype_path(@prototype)
      #concept以外の項目を入力
      fill_in 'prototype[title]', with: @edit_prototype.title
      fill_in 'prototype[catch_copy]', with: @edit_prototype.catch_copy
      fill_in 'prototype[concept]', with: ""
      #更新
      find('input[name="commit"]').click
      #編集できずにそのページに留まっていることを確認
      expect(current_path).to eq prototype_path(@prototype)
    end
    it "sp18_バリデーションによって編集ができず、そのページに留まった場合でも、入力済みの項目（画像以外）は消えない" do
      #ログイン
      sign_in(@prototype.user)
      #編集ページに遷移
      visit edit_prototype_path(@prototype)
      #concept以外の項目を入力
      fill_in 'prototype[title]', with: @edit_prototype.title
      fill_in 'prototype[catch_copy]', with: @edit_prototype.catch_copy
      fill_in 'prototype[concept]', with: ""
      #更新
      find('input[name="commit"]').click
      #編集できずにそのページに留まっていることを確認
      expect(current_path).to eq prototype_path(@prototype)
      #画像以外の入力項目が消えていないことを確認
      expect(find('#prototype_title').value).to eq @edit_prototype.title
      expect(find('#prototype_catch_copy').text).to eq @edit_prototype.catch_copy
    end
    it "sp19_正しく編集できた場合は、詳細ページへ遷移する" do
      #ログイン
      sign_in(@prototype.user)
      #プロトタイプの編集ページへ遷移
      visit edit_prototype_path(@prototype)
      #投稿に必要な情報を入力
      fill_in 'prototype[title]', with: @edit_prototype.title
      fill_in 'prototype[catch_copy]', with: @edit_prototype.catch_copy
      fill_in 'prototype[concept]', with: @edit_prototype.concept
      image_path = Rails.root.join('public/images/test_image2.jpg')
      attach_file 'prototype[image]', image_path, make_visible: true
      #プロトタイプが編集されてもPrototypeモデルのカウントが変わっていないことを確認
      expect {
        find('input[name="commit"]').click
      }.to change{ Prototype.count }.by(0)
      #詳細ページに遷移していることを確認
      expect(current_path).to eq prototype_path(@prototype)
    end
  end

  describe "プロトタイプ削除機能" do
    context "ログインしている時" do
      it "sp20-1_ログイン状態のユーザーであれば、自身の投稿したプロトタイプの詳細ページから削除ボタンをクリックすると、プロトタイプを削除できる" do
        #ログイン
        sign_in(@prototype.user)
        #詳細ページに遷移
        visit prototype_path(@prototype)
        #削除ボタンをクリックするとPrototypeモデルのカウントが減っていることを確認
        expect {
          find_link('削除する').click
        }.to change{ Prototype.count }.by(-1)
      end
      it "sp21_削除が完了すると、トップページへ遷移する" do
        #ログイン
        sign_in(@prototype.user)
        #詳細ページに遷移
        visit prototype_path(@prototype)
        #削除ボタンをクリックするとPrototypeモデルのカウントが減っていることを確認
        expect {
          find_link('削除する').click
        }.to change{ Prototype.count }.by(-1)
        #トップページへ遷移していることを確認
        expect(current_path).to eq root_path
      end
    end

    context "ログインしていない時" do
      it "sp20-2_ログイン状態のユーザーでなければ、投稿したプロトタイプの詳細ページから削除ボタンをクリックして、プロトタイプを削除できない" do
        #詳細ページに遷移
        visit prototype_path(@prototype)
        #削除ボタンがないことを確認
        expect(page).to have_no_link '削除する', href: prototype_path(@prototype)
      end
    end
  end

  describe "その他" do
    it "sp22_ログアウト状態のユーザーは、プロトタイプ新規投稿ページ・プロトタイプ編集ページに遷移しようとすると、ログインページにリダイレクトされること（ページはないが、削除機能にも同様の実装を行うこと）" do
      #プロトタイプ新規投稿ページに遷移しようとすると、ログインページにリダイレクトされることを確認
      visit new_prototype_path
      expect(current_path).to eq new_user_session_path
      #プロトタイプ編集ページに遷移しようとすると、ログインページにリダイレクトされることを確認
      visit edit_prototype_path(@prototype)
      expect(current_path).to eq new_user_session_path
      #プロトタイプ削除機能にリクエストを送ると、ログインページにリダイレクトされることを確認
      delete prototype_path(@prototype)
      expect(current_path).to eq new_user_session_path
    end
    it "sp23_ログアウト状態のユーザーであっても、トップページ・プロトタイプ詳細ページ・ユーザー詳細ページ・ユーザー新規登録ページ・ログインページには遷移できる" do
      #トップページに遷移できることを確認
      visit root_path
      expect(current_path).to eq root_path
      #プロトタイプ詳細ページに遷移できることを確認
      visit prototype_path(@prototype)
      expect(current_path).to eq prototype_path(@prototype)
      #ユーザー詳細ページに遷移できることを確認
      visit user_path(@prototype.user)
      expect(current_path).to eq user_path(@prototype.user)
      #ユーザー新規登録ページに遷移できることを確認
      visit new_user_registration_path
      expect(current_path).to eq new_user_registration_path
      #ログインページに遷移できることを確認
      visit new_user_session_path
      expect(current_path).to eq new_user_session_path
    end
    it "sp24_ログイン状態のユーザーであっても、他のユーザーのプロトタイプ編集ページのURLを直接入力して遷移しようとすると、トップページにリダイレクトされる" do
      #ログイン
      sign_in(@another_user)
      #他ユーザーのプロトタイプ編集ページのURLを直接入力して遷移しようとする
      visit edit_prototype_path(@prototype)
      #トップページにリダイレクトされることを確認
      expect(current_path).to eq root_path
    end
  end
end