class RelationshipsController < ApplicationController
  def create
    follow = Relationship.new(follower_id: params[:item_id],following_id: current_user.id)
    follow.save!
    redirect_to items_path
  end

  def destroy
    follow = Relationship.find_by(follower_id: params[:item_id],following_id: current_user.id)
    follow.destroy
    redirect_to root_path
  end

  private

  def item_params
    params.require(:item).permit(:state)
  end


end
