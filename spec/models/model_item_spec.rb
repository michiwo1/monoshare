require 'rails_helper'

RSpec.describe Item, type: :model do

  before do
   @user = FactoryBot.create(:user)
  end

  # factory_botが有効かどうかを検査。
  it "has a valid factory of user" do
    user = @user
    expect(user).to be_valid
  end

  # itemのタイトル、本文、外部キー（user_id）があれば有効。
  it "is valid with tittle,content,user_id" do
    user = @user
    item = user.items.build(tittle:"にんじん",content:"たこ焼き")
    expect(item).to be_valid
  end


end
