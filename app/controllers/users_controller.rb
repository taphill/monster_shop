class UsersController < ApplicationController

  def new
  end

  def create
    new_user = User.new(user_params)

    if params[:password] == params[:password_confirmation] && new_user.valid?
      new_user.save
      flash[:success] = 'You are now registered and logged in!'
      session[:user_id] = new_user.id
      redirect_to "/profile"
    elsif params[:password] != params[:password_confirmation]
      flash[:error] = 'Your passwords do not match' 
      redirect_to "/register"
    else
      flash[:error] = 'Missing required fields' 
      redirect_to "/register"
    end
  end

  def show
  end

  private
  def user_params
    params.permit(:name, :street_address, :city, :state, :zip, :email, :password)
  end

end
