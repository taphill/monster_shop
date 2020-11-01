class Admin::MerchantsController < ApplicationController

  def show
    @merchant = Merchant.find_by_id(params[:merchant_id])
  end

end
