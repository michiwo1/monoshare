class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @item = Item.new
  end

  def edit
    @item = Item.find(params[:id])
  end

  def create
   item = Item.new(item_params)
   item.save!
   redirect_to items_url,notice:"シェア『#{item.tittle}』しました"
  end

  def update
    item= Item.find(params[:id])
    item.update!(item_params)
    redirect_to item_url,notice:"シェア品「#{item.tittle}」を更新しました"
  end

  def destroy
   item = Item.find(params[:id])
   item.destroy
   redirect_to items_url,notice:"シェア品『#{item.tittle}』削除しました"
  end

  private

  def item_params
    params.require(:item).permit(:tittle,:content)
  end
end
