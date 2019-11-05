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
    @rentals_items = @user.rentals_items.where(state:'1')
  end

  def waiting
    @user = current_user.items
    @waiting_items = @user.where(state:'1')
  end

  def lending
    @user = current_user.items
    @lending_items = @user.where(state:'2')
  end

  def borrowing
    @user = current_user
    @borrowing_items = @user.rentals_items.where(state:'2')
  end


  def notifications
    @notifications = current_user.passive_notifications.page(params[:page]).per(10).order('updated_at DESC')
    @notifications.where(checked: false).each do |notification|
      notification.update_attributes(checked: true)

    end
  end

  def favorite
    @user = User.find(params[:id])
    @items = @user.items
    @favorite_items = @user.favorite_items
  end

end
