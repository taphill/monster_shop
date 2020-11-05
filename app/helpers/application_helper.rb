module ApplicationHelper

  def format_date(input)
    input.strftime("%m/%d/%Y")
  end

  def format_price(input)
    '$' + '%.2f' % input.round(2)
  end
end
