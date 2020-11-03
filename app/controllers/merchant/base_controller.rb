class Merchant::BaseController < ApplicationController
  before_action :require_merchant_admin

  def require_merchant_admin
    render file: 'public/404' unless current_merchant? || current_admin?
  end

end
