class SessionsController < ApplicationController
  def new
    @session = session[:user_login]
  end

  def create
    @user = User.find_by(login_params)
    session[:user_id] = @user.id
    if current_merchant?
      redirect_to '/merchant'
    elsif current_admin?
      redirect_to '/admin'
    else
      redirect_to '/profile'
    end
  end

  def destroy

  end

  private

  def login_params
    params.permit(:email)
  end
end
