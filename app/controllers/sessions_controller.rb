class SessionsController < ApplicationController

  def new
    @session = session[:user_login]
  end

  def create
    @user = User.find_by(login_params)
    session[:user_id] = @user.id
    if @user.role == 'default'
      redirect_to '/profile'
    elsif @user.role == 'merchant'
      redirect_to '/merchant'
    end
  end

  def logout

  end

  private

  def login_params
    params.permit(:email)
  end
end
