class WelcomeController < ApplicationController
  def index
  end

  def merchant
    render "merchant_dashboard"
  end

  def admin
    render "admin_dashboard"
  end
end
