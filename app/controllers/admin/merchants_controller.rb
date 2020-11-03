class Admin::MerchantsController < Admin::BaseController
  def index

  end

  def show
    @merchant = Merchant.find_by_id(params[:id])
  end
end
