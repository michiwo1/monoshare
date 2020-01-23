class RentalsController < ApplicationController

  def create
    rental = current_user.rentals.build(item_id: params[:item_id])
    rental.save
    item = Item.find(params[:item_id])
    item.state = 1
    item.save!
    redirect_to items_path

  end

  def destroy
    rental = Rental.find_by(item_id: params[:item_id], user_id: current_user.id)
    rental.destroy
    redirect_to items_path
    item = Item.find(params[:item_id])
    item.state = nil
    item.save!
  end



end
