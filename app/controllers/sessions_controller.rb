class SessionsController < ApplicationController

  def new
    @session = session[:user_login]
  end

  def create
    @user = User.find_by(login_params)
    session[:user_id] = @user.id
    redirect_to '/profile'
  end

  private

  def login_params
    params.permit(:email)
  end
end
