class Merchant::OrdersController < Merchant::BaseController

  def show
    @order = Order.find(params[:order_id])
    @merchant_id = User.find(session[:user_id]).merchant_id
  end

  def update
    item_order = ItemOrder.where(item_id: params[:item_id], order_id: params[:order_id]).first
    item_order.fulfill_status = "fulfilled"
    item_order.save

    item = Item.find(params[:item_id])
    item.inventory -= item_order.quantity
    flash[:notice] = "Item has been fulfilled" if item.save

    order = Order.find(params[:order_id])
    if order.all_fulfilled?
      order.status = "packaged"
      order.save
    end
    redirect_to request.referrer
  end
end
