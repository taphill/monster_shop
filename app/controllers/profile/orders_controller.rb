class Profile::OrdersController < Profile::BaseController

  def index
    @user = User.find(session[:user_id])
  end

  def show
    @order = Order.find(params[:order_id])
  end

end
