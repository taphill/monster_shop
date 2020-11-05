class Admin::MerchantsController < Admin::BaseController
  def index
    @merchants = Merchant.all.distinct
  end

  def show
    @merchant = Merchant.find_by_id(params[:id])
  end

  def update
    merchant = Merchant.find(params[:id])

    if enable
      merchant[:enabled] = true
      merchant.save
      merchant.enable_items
      flash[:success] = "#{merchant.name}'s account is now enabled"
      redirect_to admin_merchants_path
    else
      merchant[:enabled] = false
      merchant.save
      merchant.disable_items
      flash[:success] = "#{merchant.name}'s account is now disabled"
      redirect_to admin_merchants_path
    end
  end

  private

  def enable
    ActiveModel::Type::Boolean.new.cast(params[:enable])
  end
end
