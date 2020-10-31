class ItemsController<ApplicationController

  def index
    if params[:merchant_id]
      @merchant = Merchant.find(params[:merchant_id])
      @items = @merchant.items
    else
      @items = Item.all
    end
  end

  def show
    @item = Item.find(params[:id])
  end

  def new
    @merchant = Merchant.find(params[:merchant_id])
  end

  def create
    @merchant = Merchant.find(params[:merchant_id])
    item = @merchant.items.create(item_params)
    if item.save
      redirect_to "/merchants/#{@merchant.id}/items"
    else
      flash[:error] = item.errors.full_messages.to_sentence
      render :new
    end
  end

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
