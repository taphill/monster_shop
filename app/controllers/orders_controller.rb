class OrdersController <ApplicationController

  def index
    @user = User.find(session[:user_id])
  end

  def new

  end

  def show
    @order = Order.find(params[:id])
  end

  def create
    user = User.find(session[:user_id])
    order = user.orders.new(order_params)
    if order.save
      cart.items.each do |item,quantity|
        order.item_orders.create({
          item: item,
          quantity: quantity,
          price: item.price,
          subtotal: cart.subtotal(item, quantity),
          discount: item.discount(quantity)
          })
      end
      session.delete(:cart)
      session[:order_id] = order.id
      flash[:success] = "Your order was successfully created!"
      redirect_to "/profile/orders"
    else
      flash[:notice] = "Please complete address form to create an order."
      render :new
    end
  end


  private

  def order_params
    params.permit(:name, :address, :city, :state, :zip, :user_id)
  end
end
