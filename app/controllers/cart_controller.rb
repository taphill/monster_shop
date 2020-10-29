class CartController < ApplicationController
  def add_item
    item = Item.find(params[:item_id])
    cart.add_item(item.id.to_s)
    flash[:success] = "#{item.name} was successfully added to your cart"
    redirect_to "/items"
  end

  def change_quantity
    item = Item.find(params[:item_id])
    if params[:type] == 'up'
      cart.add_item(item.id.to_s)
    elsif params[:type] == 'down'
      cart.remove_one(item.id.to_s)
    end
    flash.now[:success] = "#{item.name} was successfully updated"
    redirect_to '/cart'
  end

  def show
    render file: "public/404" if current_admin?
    @items = cart.items
  end

  def empty
    session.delete(:cart)
    redirect_to '/cart'
  end

  def remove_item
    session[:cart].delete(params[:item_id])
    redirect_to '/cart'
  end


end
