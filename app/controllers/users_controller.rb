class UsersController < ApplicationController

  def new
  end

  def create
    if user_params.password == params[:password_confirmation]
      User.create(user_params)
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
