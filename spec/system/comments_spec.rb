require 'rails_helper'

RSpec.describe "Comments", type: :system do
  before do
    @comment = FactoryBot.build(:comment)
    @comment.user.save
    @comment.prototype.save
    #sc4の検証用にもう1つプロトタイプを生成
    @another_prototype = FactoryBot.create(:prototype)
  end

  describe "コメント投稿機能" do
    it "sc1_コメント投稿欄は、ログイン状態のユーザーへのみ、詳細ページに表示されている" do
      #詳細ページへ遷移
      visit prototype_path(@comment.prototype.id)
      #ログインしていないとコメント投稿欄が表示されてないことを確認
      expect(page).to have_no_selector '#comment_content'
      #ログイン
      sign_in(@comment.user)
      #詳細ページへ遷移
      visit prototype_path(@comment.prototype)
      #ログインしているとコメント投稿欄が表示されていることを確認
      expect(page).to have_selector '#comment_content'
    end
    it "sc2_正しくフォームを入力すると、コメントが投稿できる" do
      #ログイン
      sign_in(@comment.user)
      #詳細ページへ遷移
      visit prototype_path(@comment.prototype.id)
      #フォームに入力
      fill_in 'comment[content]', with: @comment.content
      #投稿ボタンを押すと、Commentカウントが増えていることを確認
      expect{
        find('input[name="commit"]').click
      }.to change { Comment.count }.by(1)
    end
    it "sc3_コメントを投稿すると、詳細ページに戻ってくる" do
      #ログイン
      sign_in(@comment.user)
      #詳細ページへ遷移
      visit prototype_path(@comment.prototype.id)
      #フォームに入力し、投稿
      fill_in 'comment[content]', with: @comment.content
      find('input[name="commit"]').click
      #詳細ページに戻ってくることを確認
      expect(current_path).to eq prototype_path(@comment.prototype.id)
    end
    it "sc4_コメントを投稿すると、投稿したコメントとその投稿者名が、対象プロトタイプの詳細ページにのみ表示される" do
      #ログイン
      sign_in(@comment.user)
      #詳細ページへ遷移
      visit prototype_path(@comment.prototype.id)
      #フォームに入力し、投稿
      fill_in 'comment[content]', with: @comment.content
      find('input[name="commit"]').click
      #投稿したコメントとその投稿者名が対象プロトタイプの詳細ページに表示されていることを確認
      expect(page).to have_content @comment.content
      expect(page).to have_content @comment.user.name
      #対象プロトタイプ以外の詳細ページに遷移
      visit prototype_path(@another_prototype)
      #投稿したコメントとその投稿者名が対象のプロトタイプ以外の詳細ページに表示されていないことを確認
      expect(page).to have_no_content @comment.content
      expect(page).to have_no_content @comment.user.name      
    end
    it "sc5_フォームを空のまま投稿しようとすると、投稿できずにそのページに留まる" do
      #ログイン
      sign_in(@comment.user)
      #詳細ページへ遷移
      visit prototype_path(@comment.prototype.id)
      #フォームが空のまま、投稿
      find('input[name="commit"]').click
      #そのページに留まることを確認
      expect(current_path).to eq prototype_path(@comment.prototype.id)
      #投稿できていないことを確認
      expect(page).to have_no_selector '.comments_list'
    end
  end
end