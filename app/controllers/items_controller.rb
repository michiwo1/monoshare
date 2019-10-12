class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show

    @item = Item.find_by(id: params[:id])
    # 変数@userを定義してください
    @user = @item.user
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

  private

  def item_params
    params.require(:item).permit(:tittle,:content)
  end
end
