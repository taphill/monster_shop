class Admin::MerchantsController < ApplicationController
  def index
    @merchants = Merchant.all
  end

  def update
    merchant = Merchant.find(params[:id])

    if enable
      merchant[:enabled] = true
      merchant.save
      flash[:success] = "#{merchant.name}'s account is now enabled"
      redirect_to admin_merchants_path
    else
      merchant[:enabled] = false
      merchant.save
      flash[:success] = "#{merchant.name}'s account is now disabled"
      redirect_to admin_merchants_path
    end
  end

  private
  
  def enable
    ActiveModel::Type::Boolean.new.cast(params[:enable])
  end
end
