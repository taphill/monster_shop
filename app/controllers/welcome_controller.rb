class WelcomeController < ApplicationController
  def index
  end

  def merchant
    # render status: 404 if !current_user
    @merchant = current_user.merchant if current_merchant?
    render file: "public/404" unless current_merchant?
    render "merchant_dashboard" if current_merchant?
  end

  def admin
    @orders = Order.all
    render file: "public/404" unless current_admin?
    render "admin_dashboard" if current_admin?
  end
end
