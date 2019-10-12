class UsersController < ApplicationController
before_action :authenticate_user!
  def index
    @users = User.all
  end

  def set_item
      @users = current_user.user.find(params[:id])
  end

  def show
     @user = User.find(params[:id])
  end
end
