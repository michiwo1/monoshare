class ItemsController < ApplicationController
  before_action :authenticate_user!, except: [:index]


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
    @borrowing_items = current_user.rentals_items.where(state:'2')
    @waiting_items = current_user.items.where(state:'1')
  end

  def edit
    @item = current_user.items.find(params[:id])
  end

  def create
   @item = Item.new(item_params.merge(user_id: current_user.id))
   if @item.share_start_date.nil? || @item.share_end_date.nil?
     flash[:alert] = "シェア期間を入力してください"
     render :new
     return
   else
     sabun = (@item.share_start_date - Date.today).to_i
     unless sabun >= 0
       flash[:alert] = "シェア開始日は本日より以前の日付にできません"
       render :new
       return
     end
     sabun = (@item.share_end_date - @item.share_start_date).to_i
     unless sabun <= 365
       flash[:alert] = "シェア期間の最長365日間までです"
       render :new
       return
     end
     unless sabun >= 1
       flash[:alert] = "シェア終了日は本日以降の日付でお願いします"
       render :new
       return
     end
   end
   if @item.save
    redirect_to items_url,notice:"「#{@item.tittle}」をシェアしました"
   else
    Rails::logger::debug(@item.errors.messages)
    @item = Item.new(item_params)
    flash[:alert] = "シェア品名を入力してください"
    render :new
    return
   end
  end

  def update
    @item = current_user.items.find(params[:id])
    @item = Item.new(item_params.merge(user_id: current_user.id))
    if @item.share_start_date.nil? || @item.share_end_date.nil?
      flash[:alert] = "シェア期間を入力してください"
      render :edit
      return
    else
      sabun = (@item.share_start_date - Date.today).to_i
      unless sabun >= 0
        flash[:alert] = "シェア開始日は本日より以前の日付にできません"
        render :edit
        return
      end
      sabun = (@item.share_end_date - @item.share_start_date).to_i
      unless sabun <= 365
        flash[:alert] = "シェア期間の最長365日間までです"
        render :edit
        return
      end
      unless sabun >= 1
        flash[:alert] = "シェア終了日は本日以降の日付でお願いします"
        render :edit
        return
      end
    end
    if @item.update(item_params)
      redirect_to items_url,notice:"シェア品「#{@item.tittle}」を更新しました"
      return
    else
      flash[:alert] = "シェア品名を入力してください"
      render :edit
      return
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
    item.state = nil
    item.save!
    redirect_to items_path
  end



  private

  def item_params
    params.require(:item).permit(:tittle,:content,:image,:image_cache,:state,:share_start_date, :share_end_date, :category_id)
  end






end
