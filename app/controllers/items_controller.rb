class ItemsController<ApplicationController

  def index
    @items = Item.all
  end

  def show
    @item = Item.find(params[:id])
  end


  def edit
    @item = Item.find(params[:id])
  end

  def update
    @item = Item.find(params[:id])
    check_default_image(@item)
    @item.update(item_params)
    if params[:status]
      update_status
    elsif @item.save
      flash[:alert] = "Item #{@item.id} has been successfully updated!"
      redirect_to "/merchants/#{@item.merchant_id}/items"
    else
      flash[:error] = @item.errors.full_messages.to_sentence
      render :edit
    end
  end

  def destroy
    item = Item.find(params[:id])
    Review.where(item_id: item.id).destroy_all
    item.destroy
    flash[:alert] = 'This item is now deleted.'
    redirect_to "/merchants/#{item.merchant_id}/items"
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

  def check_default_image(item)
    if params[:image] == ''
      params[:image] = '/images/image.png'
    end
  end

end
