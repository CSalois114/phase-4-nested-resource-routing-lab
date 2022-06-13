class ItemsController < ApplicationController
rescue_from ActiveRecord::RecordNotFound, with: :user_not_found

  def index
    if params[:user_id]
      items = User.find(params[:user_id]).items
    else 
      items = Item.all
    end
      render json: items, include: :user   
  end

  def show 
    item = Item.find(params[:id])
    render json: item, include: :user
  rescue ActiveRecord::RecordNotFound
    p "item not found"
    render json: {error: "Item not found"}, status: :not_found
  end

  def create 
    render json: Item.create!(item_params), status: :created
  end

  private 

  def item_params
    params.permit(:user_id, :name, :description, :price)
  end

  def user_not_found
    p "user not found"
    render json: {error: "User not found"}, status: :not_found
  end
end
