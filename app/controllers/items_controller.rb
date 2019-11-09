class ItemsController < ApplicationController
  before_action :authenticate_user!


  def index
    @items = Item.where(state:nil)
    @items = Item.page(params[:page]).per(16).order('updated_at DESC')
  end

  def show
    @item = Item.find_by(id: params[:id])
    @comment = @item.comments.build
  end

  def new
    @item = Item.new
  end

  def edit
    @item = current_user.items.find(params[:id])
  end

  def create
   @item = Item.new(item_params.merge(user_id: current_user.id))
   if @item.share_start_date.nil? || @item.share_end_date.nil?
     flash[:alert] = "シェア期間を入力してください"
     redirect_to new_item_path
     return
   else
     sabun = (@item.share_start_date - Date.today).to_i
     unless sabun >= 0
       flash[:alert] = "シェア開始日は本日以降の日付にできません"
       redirect_to new_item_path
       return
     end
     sabun = (@item.share_end_date - @item.share_start_date).to_i
     unless sabun <= 365
       flash[:alert] = "シェア期間の最長365日間までです"
       redirect_to new_item_path
       return
     end
     unless sabun >= 1
       flash[:alert] = "シェア終了日は本日以降の日付でお願いします"
       redirect_to new_item_path
       return
     end
   end
   if @item.save
    redirect_to items_url,notice:"「#{@item.tittle}」をシェアしました"
   else
    redirect_to new_item_path,alert:"シェア品名を入力してください"
   end
  end

  def update
    @item= current_user.items.find(params[:id])
    if @item.share_start_date.nil? || @item.share_end_date.nil?
      flash[:alert] = "シェア期間を入力してください"
      redirect_to edit_item_path
      return
    else
      sabun = (@item.share_start_date - Date.today).to_i
      unless sabun >= 0
        flash[:alert] = "シェア開始日は本日以降の日付にできません"
        redirect_to edit_item_path
        return
      end
      sabun = (@item.share_end_date - @item.share_start_date).to_i
      unless sabun <= 365
        flash[:alert] = "シェア期間の最長365日間までです"
        redirect_to edit_item_path
        return
      end
      unless sabun >= 1
        flash[:alert] = "シェア終了日は本日以降の日付でお願いします"
        redirect_to edit_item_path
        return
      end
    end
    if @item.update!(item_params)
      redirect_to items_url,notice:"シェア品「#{@item.tittle}」を更新しました"
    else
      redirect_to edit_item_path,alert:"シェア品名を入力してください"
    end
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
    params.require(:item).permit(:tittle,:content,:image,:state,:share_start_date, :share_end_date)
  end




end
