class Merchant::OrdersController < Merchant::BaseController

  def show
    @order = Order.find(params[:order_id])
    @merchant_id = User.find(session[:user_id]).merchant_id
  end

end
