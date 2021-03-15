module ApplicationHelper
  def format_currency_value(number)
    number_to_currency(number, unit: "EUR", separator: ".", delimiter: ",", format: "%n %u")
  end
end
