module ApplicationHelper

  def format_date(input)
    input.strftime("%m/%d/%Y")
  end
end
