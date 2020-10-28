class WelcomeController < ApplicationController
  def index
  end

  def merchant
    render "merchant_dashboard"
  end
end
