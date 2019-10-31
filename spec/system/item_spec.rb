require 'rails_helper'

RSpec.describe 'ログインとログアウト', type: :feature do
  before do
    # ユーザを作成する
    User.create!(username:"test",email: 'foo@example.com', password: '123456')
  end
  it '初期画面にMONOシェアリンクかがあるか検証' do
    visit root_path
    expect(page).to have_link 'MONOシェア'
  end
  it '初期画面にプロフィールがあるか検証' do
    visit root_path
    expect(page).to have_link 'シェアする'
  end



end
