require 'rails_helper'

RSpec.describe Item, type: :model do

  before do
   @user = FactoryBot.create(:user)
  end

  # factory_botが有効かどうかを検査。
  it "factory_botが有効かどうかを検査" do
    user = @user
    expect(user).to be_valid
  end

  # itemのタイトル、本文、外部キー（user_id）があれば有効。
  it "itemのタイトル、本文、外部キー（user_id）があれば有効" do
    user = @user
    item = user.items.build(tittle:"にんじん",content:"たこ焼き")
    expect(user).to be_valid
  end


end
