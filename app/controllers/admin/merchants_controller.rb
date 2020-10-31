class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:id])
    merchant[:enabled] = false
    merchant.save

    flash[:success] = "#{merchant.name}'s account is now disabled"
    redirect_to admin_merchants_path
  end
end
