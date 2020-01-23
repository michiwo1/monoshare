class FavoritesController < ApplicationController
  def create
    favorite = current_user.favorites.build(item_id: params[:item_id])
    favorite.save
    favorite_notification = Item.find(params[:item_id])
    favorite_notification.notification_favorite(current_user)
    redirect_back(fallback_location: root_path)
  end

  def destroy
    favorite = Favorite.find_by(item_id: params[:item_id], user_id: current_user.id)
    favorite.destroy
    redirect_back(fallback_location: root_path)
  end
end
