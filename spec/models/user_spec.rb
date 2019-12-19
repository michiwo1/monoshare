require 'rails_helper'

RSpec.describe User, type: :model do

  # username,email,passwordがあれば有効
  it "username,email,passwordがあれば有効" do
    user = User.new(username:"にんじん",email:"dddd@dddd",password:123456)
    expect(user).to be_valid
  end

  # usernameが入力されていないので保存できない（結果はfalse）
  it "usernameが入力されていないので保存できない（結果はfalse）" do
    user = User.new(email:"dddd@dddd",password:123456)
    expect(user.save).to be_falsey
  end

  # passwordが入力されていないので保存できない（結果はfalse）
  it "passwordが入力されていないので保存できない（結果はfalse）" do
    user = User.new(username:"にんじん",email:"dddd@dddd")
    expect(user.save).to be_falsey
  end

  # emailが入力されていないので保存できない（結果はfalse）
  it "emailが入力されていないので保存できない（結果はfalse）" do
    user = User.new(username:"にんじん",password:123456)
    expect(user.save).to be_falsey
  end

  # 必須項目が入力されていないので保存できない（結果はfalse）
  it "必須項目が入力されていないので保存できない（結果はfalse）" do
    user = User.new
    expect(user.save).to be_falsey
  end


end
