class Admin::MerchantsController < Admin::BaseController
  def index

  end

  def show
    require "pry"; binding.pry
    @merchant = Merchant.find_by_id(params[:merchant_id])
    render
  end
end
