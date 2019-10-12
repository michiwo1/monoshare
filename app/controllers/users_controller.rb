class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def set_item
      @item = current_user.item.find(params[:id])
  end

  def show
     @user = User.find(params[:id])
  end
end
