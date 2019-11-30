class SearchController < ApplicationController
  def index
    @items = Item.where(state:nil)
    @search = @items.ransack(params[:q])
    @searchs = @search.result.page(params[:page]).per(100000).order('updated_at DESC')
  end
end
