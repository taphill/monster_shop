class UsersController < ApplicationController

  def new
  end

  def create
    if params[:password] == params[:password_confirmation]
      new_user = User.create(user_params)
      flash[:success] = 'You are now registered and logged in!'
      session[:user_id] = new_user.id
      redirect_to "/profile"
    end
  end

  def show
  end

  private
  def user_params
    params.permit(:name, :street_address, :city, :state, :zip, :email, :password)
  end

end
