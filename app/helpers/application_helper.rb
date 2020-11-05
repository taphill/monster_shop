module ApplicationHelper

  def format_date(input)
    input.strftime("%m/%d/%Y")
  end

  def price_format(input)
    "$#{input.round(2)}"
  end
end
