class ItemsController<ApplicationController

  def index
    @items = Item.all
    # @merchant = Merchant.find(params[:merchant_id])
  end

  def show
    @item = Item.find(params[:id])
  end

  # def new
  #   @merchant = Merchant.find(params[:merchant_id])
  #   @item = Item.new
  # end

  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    @item.update(item_params)
    if params[:status]
      update_status
    elsif @item.save
      redirect_to "/items/#{@item.id}"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    if params[:merchant_id]
      merchant = Merchant.find(params[:merchant_id])
      flash[:alert] = 'This item is now deleted.'
      redirect_to "/merchants/#{merchant.id}/items"
    else
      redirect_to "/items"
    end
  end

  def update_status
    @item = Item.find(params[:id])
    if params[:status] == 'deactivate'
      @item.update(:active? => false)
      flash[:alert] = 'This item is no longer for sale.'
    elsif params[:status] == 'activate'
      @item.update(:active? => true)
      flash[:alert] = 'This item is available for sale.'
    end
    redirect_to "/merchants/#{@item.merchant_id}/items"
  end

  private

  def item_params
    params.permit(:name,:description,:price,:inventory,:image)
  end

end
