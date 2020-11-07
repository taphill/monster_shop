class Merchant::DiscountsController < Merchant::BaseController
  def index
    @merchant = current_user.merchant if current_merchant?
  end

  def show
    @discount = Discount.find(params[:id])
  end

  def new
    @discount = Discount.new
  end

  def create
    merchant = Merchant.find(current_user.merchant_id)
    discount = merchant.discounts.new(discount_params)

    if discount.save
      flash[:success] = 'New discount successfully created'
      redirect_to merchant_discounts_path
    else
      flash[:error] = "We're sorry. Something went wrong"
      redirect_to merchant_discounts_path
    end
  end

  private

  def discount_params
    params.require(:discount).permit(:percentage, :item_quantity)
  end
end
