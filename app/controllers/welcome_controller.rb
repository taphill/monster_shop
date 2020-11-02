class WelcomeController < ApplicationController
  def index
  end

  def merchant
    # render status: 404 if !current_user
    render file: "public/404" unless current_merchant?
    render "merchant_dashboard" if current_merchant?
  end
end
