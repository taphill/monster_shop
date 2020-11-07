class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant if current_merchant?
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
  end
end
