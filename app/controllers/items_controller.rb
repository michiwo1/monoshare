class ItemsController < ApplicationController
  before_action :authenticate_user!

  def index
    @items = Item.where(state:nil)
  end

  def show
    @item = Item.find_by(id: params[:id])
    # 変数@userを定義してください
  end

  def new
    @item = Item.new
  end

  def edit
    @item = current_user.items.find(params[:id])
  end

  def create
   @item = Item.new(item_params.merge(user_id: current_user.id))
   if @item.save
    redirect_to items_url,notice:"シェア『#{@item.tittle}』しました"
   else
    render :new
   end
  end

  def update
    item= current_user.items.find(params[:id])
    item.update!(item_params)
    redirect_to item_url,notice:"シェア品「#{item.tittle}」を更新しました"
  end

  def destroy
   item = current_user.items.find(params[:id])
   item.destroy
   redirect_to items_url,notice:"シェア品『#{item.tittle}』削除しました"
  end

  def ensure_correct_user
    @item = item.find_by(id:params[:id])
    if @item.user_id != @current_user.id
      flash[:notice] = "権限がありません"
      redirect_to("/items/index")
    end
  end

  def apply
    rental = current_user.rentals.build(item_id: params[:item_id])
    rental.save
    item = Item.find(params[:item_id])
    item.state = 1
    item.save!
    item_notification = Item.find(params[:item_id])
    item_notification.notification_apply(current_user)
    redirect_to items_path
  end

  def cancel
    rental = Rental.find_by(item_id: params[:item_id])
    rental.destroy
    item = Item.find(params[:item_id])
    item.state = nil
    item.save!
    item_notification = Notification.find_by(item_id: params[:item_id])
    item_notification.destroy
    item_notification_cancel = Item.find(params[:item_id])
    item_notification_cancel.notification_cancel(current_user)
    redirect_to items_path
  end

  def approve
    item = Item.find(params[:item_id])
    item.state = 2
    item.save!
    item_notification = Item.find(params[:item_id])
    item_notification.notification_approve(current_user)
    redirect_to items_path
  end

  def reject
    item_notification = Item.find(params[:item_id])
    item_notification.notification_reject(current_user)
    rental = Rental.find_by(item_id: params[:item_id])
    rental.destroy
    item = Item.find(params[:item_id])
    item.state = nil
    item.save!
    redirect_to items_path
  end

  def complete
    item_notification = Item.find(params[:item_id])
    item_notification.notification_complete(current_user)
    rental = Rental.find_by(item_id: params[:item_id])
    rental.destroy
    item = Item.find(params[:item_id])
    item.state = 3
    item.save!
    redirect_to items_path
  end



  private

  def item_params
    params.require(:item).permit(:tittle,:content,:image,:state)
  end




end
