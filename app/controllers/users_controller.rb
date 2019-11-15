class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    @users = User.all
  end

  def show
     @user = User.find(params[:id])
  end

  def applying
    @user = current_user
    # gemのenumerize使いたい
    # @applying_items = @user.rentals_items.where(state: :waiting)
    @applying_items = @user.rentals_items.where(state: '1')
  end

  def waiting
    @waiting_items = @user.where(state: '1')
  end

  def lending
    @lending_items = @user.where(state: '2')
  end

  def borrowing
    @borrowing_items = current_user.rentals_items.where(state: '2')
  end

  def notifications
    @notifications = current_user.passive_notifications.page(params[:page]).per(10).order(updated_at: :desc)
    # データの更新はGETではなくPOSTまたはPATCH通信で行う。
    # @notifications.where(checked: false).update_all(checked: true)
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
