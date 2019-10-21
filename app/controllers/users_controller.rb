class UsersController < ApplicationController
before_action :authenticate_user!, except: [:index]

  def index
    @users = User.all
  end

  def set_item
      @users = current_user.user.find(params[:id])
  end

  def show
     @user = User.find(params[:id])
  end


  def applying
    @user = current_user
    @rentals_items = @user.rentals_items.where(state:'1')# 追加s
  end

  def waiting
    @user = current_user.items
    @waiting_items = @user.where(state:'1')
  end

  def lending
    @user = current_user.items
    @lending_items = @user.where(state:'2')
  end

  def waiting
    @user = current_user.items
    @waiting_items = @user.where(state:'1')
  end



end
