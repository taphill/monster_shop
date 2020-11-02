class Admin::OrdersController < Admin::BaseController
  def update
    order = Order.find(params[:id])
    order.update(status: 2)
    order.save
    redirect_to admin_root_path
  end
end
