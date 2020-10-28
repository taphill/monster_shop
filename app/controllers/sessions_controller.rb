class SessionsController < ApplicationController
  def new
    @session = session[:user_login]
  end

  def create
    @user = User.find_by(login_params)
    session[:user_id] = @user.id if @user.authenticate(params[:password])
    flash[:notice] = "Welcome, #{@user.name}" if current_user
    if current_merchant?
      redirect_to '/merchant'
    elsif current_admin?
      redirect_to '/admin'
    elsif current_user
      redirect_to '/profile'
    else
      flash[:error] = "Your login credentials were incorrect."
      redirect_to login_path
    end
  end

  def destroy

  end

  private

  def login_params
    params.permit(:email)
  end
end
