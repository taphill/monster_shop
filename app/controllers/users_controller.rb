class UsersController < ApplicationController

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if params[:password] == params[:password_confirmation] && @user.valid?
      @user.save
      flash[:success] = 'You are now registered and logged in!'
      session[:user_id] = @user.id
      redirect_to "/profile"
    elsif params[:password] != params[:password_confirmation]
      flash[:error] = 'Your passwords do not match' 
      redirect_to "/register"
    elsif @user.email_exists?
      flash[:error] = 'A user with this email already exists'
      render :new
    else
      flash[:error] = 'Missing required fields' 
      render :new
    end
  end

  def show
  end

  private

  def user_params
    params.require(:user).permit(:name, :street_address, :city, :state, :zip, :email, :password)
  end
end
