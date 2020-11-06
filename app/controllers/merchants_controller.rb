class MerchantsController <ApplicationController

  def index
    return redirect_to admin_merchants_path if current_admin?
    @merchants = Merchant.all
  end

  def show
    if current_admin?
      redirect_to "/admin/merchants/#{params[:id]}"
    else
      @merchant = Merchant.find(params[:id])
    end
  end

  def new
  end

  def create
    merchant = Merchant.create(merchant_params)
    if merchant.save
      redirect_to merchants_path
    else
      flash[:error] = merchant.errors.full_messages.to_sentence
      render :new
    end
  end

  def edit
    @merchant = Merchant.find(params[:id])
  end

  def update
    @merchant = Merchant.find(params[:id])
    @merchant.update(merchant_params)
    if @merchant.save
      redirect_to "/merchants/#{@merchant.id}"
    else
      flash[:error] = @merchant.errors.full_messages.to_sentence
      render :edit
    end
  end

  private

  def merchant_params
    params.permit(:name,:address,:city,:state,:zip)
  end

end
