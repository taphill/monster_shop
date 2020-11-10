# frozen_string_literal: true

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
    @discount = merchant.discounts.new(discount_params)

    return render :new unless valid?(@discount)

    if @discount.save
      flash[:success] = 'New discount successfully created'
      redirect_to merchant_discounts_path
    else
      flash_error
      render :new
    end
  end

  def edit
    @discount = Discount.find(params[:id])
  end

  def update
    @discount = Discount.find(params[:id])
    @discount.update(discount_params)

    return render :edit unless valid?(@discount)

    if @discount.save
      flash[:success] = 'Discount successfully edited'
      redirect_to merchant_discounts_path
    else
      flash_error
      render :edit
    end
  end

  def destroy
    discount = Discount.find(params[:id])
    discount.destroy
    flash[:success] = 'Discount has been deleted'
    redirect_to merchant_discounts_path
  end

  private

  def discount_params
    params.require(:discount).permit(:percentage, :item_quantity)
  end

  def flash_error
    flash[:error] = @discount.errors.full_messages.to_sentence
  end

  def valid?(discount)
    if !discount.valid_item_quantity?
      flash[:error] = "A discount with #{discount.item_quantity} item(s) already exists"
      false
    elsif !discount.logical_discount?
      flash[:error] = "A larger discount with a smaller item threshold already exists"
      false
    else
      true
    end
  end
end
