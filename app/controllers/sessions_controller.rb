class SessionsController < ApplicationController

  def new
    @session = session[:user_login]
  end
end
