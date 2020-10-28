class SessionsController < ApplicationController
  def new
    @session = session[:user_login]
  end

  def create
    @user = User.find_by(login_params)
    if @user && @user.authenticate(params[:password])
      session[:user_id] = @user.id
      flash[:notice] = "Welcome, #{@user.name}" if current_user
      return redirect_to '/merchant' if current_merchant?
      return redirect_to '/admin' if current_admin?
      return redirect_to '/profile' if current_user
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
