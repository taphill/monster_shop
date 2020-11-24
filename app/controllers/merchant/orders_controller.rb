class Merchant::OrdersController < Merchant::BaseController

  def show
    @order = Order.find(params[:id])
    @merchant_id = User.find(session[:user_id]).merchant_id
  end

  def update
    item_order = ItemOrder.where(item_id: params[:item_id], order_id: params[:id]).first
    item_order.fulfill_status = "fulfilled"
    item_order.save

    item = Item.find(params[:item_id])
    item.inventory -= item_order.quantity
    flash[:notice] = "Item has been fulfilled" if item.save

    order = Order.find(params[:id])
    order.status_check
    redirect_to request.referrer
  end
end
