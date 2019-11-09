require 'rails_helper'

RSpec.describe 'リンクテスト', type: :feature do
  before do
    # ユーザを作成する
    @user = User.create!(username:"test",email: 'foo@example.com', password: '123456')
  end

  it '初期画面にMONOシェアリンクかがあるか検証' do
    visit root_path
    expect(page).to have_link 'MONOシェア'
  end

  it 'ログインページ⇨新規ユーザー登録' do
    visit new_user_session_path
    click_on "登録する"
    expect(page).to have_content '新規ユーザー登録'
  end

  it '新規ユーザー登録⇨ログインページ' do
    visit new_user_registration_path
    click_on "ログインする"
    expect(page).to have_content 'ログイン'
  end

  it "ログインできるかテスト" do
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'ログイン'
    expect(page).to have_content 'ログインしました。'
  end

  it "通知一覧リンクテスト" do
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'ログイン'
    click_on "通知一覧"
    expect(page).to have_selector 'h4', text: '通知一覧'
  end

  it "プロフィールリンクテスト" do
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'ログイン'
    click_on "プロフィール"
    expect(page).to have_selector 'h4', text: 'プロフィール'
  end

  it "ユーザー一覧リンクテスト" do
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'ログイン'
    click_on "ユーザー一覧"
    expect(page).to have_selector 'h4', text: 'ユーザー一覧'
  end

  it "ログアウトリンクテスト" do
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'ログイン'
    click_on "ログアウト"
    expect(page).to have_selector 'h4', text: 'ログイン'
  end

  it "申請中一覧リンクテスト" do
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'ログイン'
    click_on "申請中一覧"
    expect(page).to have_selector 'h1', text: '申請中一覧'
  end

  it "承認待ち一覧リンクテスト" do
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'ログイン'
    click_on "承認待ち一覧"
    expect(page).to have_selector 'h1', text: '承認待ち一覧'
  end

  it "貸し出し中一覧リンクテスト" do
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'ログイン'
    click_on "貸し出し中一覧"
    expect(page).to have_selector 'h1', text: '貸し出し中一覧'
  end

  it "借りているもの一覧リンクテスト" do
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'ログイン'
    click_on "借りているもの一覧"
    expect(page).to have_selector 'h1', text: '借りているもの一覧'
  end

  it "シェアするリンクテスト" do
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'ログイン'
    click_on "シェアする"
    expect(page).to have_selector 'h4', text: 'シェア情報を入力'
  end

  it "プロフィール変更リンクテスト" do
    visit new_user_session_path
    fill_in 'user_email', with: @user.email
    fill_in 'user_password', with: @user.password
    click_on 'ログイン'
    click_on "プロフィール"
    click_on "プロフィール変更"
    expect(page).to have_selector 'h4', text: 'ユーザー編集'
  end

end
