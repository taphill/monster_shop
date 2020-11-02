class Merchants::ItemsController < ApplicationController
  def index
    @merchant = Merchant.find(params[:merchant_id])
    @items = @merchant.items
    render 'items/index'
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
    @item = Item.new
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    @item = @merchant.items.new(item_params)
    check_default_image(@item)
    if @item.save
      flash[:alert] = 'New item saved successfully!'
      redirect_to "/merchants/#{@merchant.id}/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :new
    end
  end

  private

  def item_params
    params[:item].permit(:name,:description,:price,:inventory,:image)
  end

  def check_default_image(item)
    if params[:item][:image] == ''
      item.update(image: '/images/image.png')
    end
  end
end
