class ItemsController < ApplicationController
  def index
    @items = Item.all
  end

  def show
  end

  def new
    @item = Item.new
  end

  def edit
  end

  def create
   item = Item.new(item_params)
   item.save!
   redirect_to items_url,notice:"シェア『#{item.tittle}』しました"
  end



  private

  def item_params
    params.require(:item).permit(:tittle,:content)
  end
end
